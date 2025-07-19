#include "Solver.h"
#include <QDebug>
#include <algorithm>
#include <numeric>

/**
 * @brief Constructor initializes solver with default parameters
 * Sets reasonable defaults for maximum iterations and diagonal checking
 */
Solver::Solver(QObject *parent)
    : QObject(parent), 
      m_maxIterations(1000000), 
      m_currentIterations(0), 
      m_checkDiagonal(false) {
    // Reserve space for better performance
}

/**
 * @brief Enable or disable diagonal constraint checking for X-Sudoku variants
 */
void Solver::setCheckDiagonal(bool enabled) {
    m_checkDiagonal = enabled;
}

/**
 * @brief Set maximum iterations to prevent runaway recursion
 */
void Solver::setMaxIterations(int maxIter) {
    m_maxIterations = maxIter > 0 ? maxIter : 1000000;
}

/**
 * @brief Main entry point for solving Sudoku puzzles from QML
 * Converts QML grid format, validates input, solves, and emits result
 */
void Solver::solvePuzzle(QVariantList qmlGrid) {
    // Reset iteration counter for new solve attempt
    m_currentIterations = 0;
    
    // Input validation
    if (qmlGrid.size() != GRID_SIZE) {
        qDebug() << "Invalid grid size:" << qmlGrid.size() << "expected" << GRID_SIZE;
        emit sudokuSolved(false, QVariantList());
        return;
    }
    
    // Convert QML grid to internal format with validation
    Grid grid(GRID_SIZE, std::vector<int>(GRID_SIZE));
    for (int i = 0; i < GRID_SIZE; ++i) {
        QVariantList row = qmlGrid[i].toList();
        if (row.size() != GRID_SIZE) {
            qDebug() << "Invalid row size at row" << i << ":" << row.size();
            emit sudokuSolved(false, QVariantList());
            return;
        }
        
        for (int j = 0; j < GRID_SIZE; ++j) {
            int value = row[j].toInt();
            // Validate cell values are in valid range
            if (value < 0 || value > MAX_NUM) {
                qDebug() << "Invalid cell value at (" << i << "," << j << "):" << value;
                emit sudokuSolved(false, QVariantList());
                return;
            }
            grid[i][j] = value;
        }
    }

    // Validate initial grid state for conflicts
    if (!isInitialGridValid(grid)) {
        qDebug() << "Initial grid contains conflicts - unsolvable";
        emit sudokuSolved(false, QVariantList());
        return;
    }

    // Create working copy and attempt to solve
    Grid solved = grid;
    bool solvable = solveSudoku(solved);

    // Convert solution back to QML format
    QVariantList qmlSolution;
    if (solvable) {
        qmlSolution.reserve(GRID_SIZE);
        for (const auto &row : solved) {
            QVariantList qmlRow;
            qmlRow.reserve(GRID_SIZE);
            for (int cell : row) {
                qmlRow.append(cell);
            }
            qmlSolution.append(QVariant(qmlRow));
        }
        qDebug() << "Puzzle solved in" << m_currentIterations << "iterations";
    } else {
        qDebug() << "Puzzle unsolvable after" << m_currentIterations << "iterations";
    }

    emit sudokuSolved(solvable, qmlSolution);
}

/**
 * @brief Optimized recursive backtracking solver with smart cell selection
 * Uses most constrained variable heuristic for better performance
 */
bool Solver::solveSudoku(Grid &grid) {
    // Check iteration limit to prevent infinite recursion
    if (m_currentIterations++ > m_maxIterations) {
        qDebug() << "Maximum iterations reached:" << m_maxIterations;
        return false;
    }

    // Find next empty cell using optimized strategy
    int row, col;
    if (!findEmptyCell(grid, row, col)) {
        return true; // No empty cells - puzzle solved!
    }

    // Get valid numbers for this position (constraint propagation)
    std::vector<int> validNums = getValidNumbers(grid, row, col);
    
    // Try each valid number (already filtered for efficiency)
    for (int num : validNums) {
        grid[row][col] = num;
        
        // Recursive call - if this path leads to solution, we're done
        if (solveSudoku(grid)) {
            return true;
        }
        
        // Backtrack: undo the move and try next number
        grid[row][col] = 0;
    }
    
    // No valid number worked - backtrack to previous level
    return false;
}

/**
 * @brief Optimized constraint validation with early termination
 * Checks row, column, 3x3 box, and optional diagonal constraints
 */
bool Solver::isValid(const Grid &grid, int row, int col, int num) const {
    // Check row and column simultaneously for better cache performance
    for (int x = 0; x < GRID_SIZE; ++x) {
        if (grid[row][x] == num || grid[x][col] == num) {
            return false;
        }
    }

    // Check 3x3 box with optimized bounds calculation
    const int boxStartRow = (row / BOX_SIZE) * BOX_SIZE;
    const int boxStartCol = (col / BOX_SIZE) * BOX_SIZE;
    
    for (int i = 0; i < BOX_SIZE; ++i) {
        for (int j = 0; j < BOX_SIZE; ++j) {
            if (grid[boxStartRow + i][boxStartCol + j] == num) {
                return false;
            }
        }
    }

    // Check diagonal constraints if enabled (X-Sudoku variant)
    if (m_checkDiagonal) {
        // Main diagonal (top-left to bottom-right)
        if (row == col) {
            for (int i = 0; i < GRID_SIZE; ++i) {
                if (grid[i][i] == num) {
                    return false;
                }
            }
        }
        
        // Anti-diagonal (top-right to bottom-left)
        if (row + col == GRID_SIZE - 1) {
            for (int i = 0; i < GRID_SIZE; ++i) {
                if (grid[i][GRID_SIZE - 1 - i] == num) {
                    return false;
                }
            }
        }
    }

    return true;
}

/**
 * @brief Validates initial puzzle state for rule violations
 * Temporarily removes each filled cell to check if its value is valid
 */
bool Solver::isInitialGridValid(const Grid &grid) {
    // Create a mutable copy for validation
    Grid tempGrid = grid;
    
    for (int row = 0; row < GRID_SIZE; ++row) {
        for (int col = 0; col < GRID_SIZE; ++col) {
            int val = tempGrid[row][col];
            if (val != 0) {
                // Temporarily remove the value to test validity
                tempGrid[row][col] = 0;
                if (!isValid(tempGrid, row, col, val)) {
                    return false; // Conflict found
                }
                // Restore the value
                tempGrid[row][col] = val;
            }
        }
    }
    return true;
}

/**
 * @brief Find next empty cell using most constrained variable heuristic
 * Selects the empty cell with fewest possible values for better pruning
 */
bool Solver::findEmptyCell(const Grid &grid, int &row, int &col) const {
    int minOptions = MAX_NUM + 1;
    bool found = false;
    
    for (int r = 0; r < GRID_SIZE; ++r) {
        for (int c = 0; c < GRID_SIZE; ++c) {
            if (grid[r][c] == 0) {
                // Count valid options for this cell
                int options = 0;
                for (int num = MIN_NUM; num <= MAX_NUM; ++num) {
                    if (isValid(grid, r, c, num)) {
                        options++;
                    }
                }
                
                // If no valid options, this path is impossible
                if (options == 0) {
                    return false;
                }
                
                // Select cell with minimum options (most constrained)
                if (options < minOptions) {
                    minOptions = options;
                    row = r;
                    col = c;
                    found = true;
                    
                    // If only one option, this is optimal
                    if (options == 1) {
                        return true;
                    }
                }
            }
        }
    }
    
    return found;
}

/**
 * @brief Get all valid numbers for a specific cell position
 * Pre-filters valid options to reduce backtracking iterations
 */
std::vector<int> Solver::getValidNumbers(const Grid &grid, int row, int col) const {
    std::vector<int> validNums;
    validNums.reserve(MAX_NUM); // Reserve space for efficiency
    
    for (int num = MIN_NUM; num <= MAX_NUM; ++num) {
        if (isValid(grid, row, col, num)) {
            validNums.push_back(num);
        }
    }
    
    return validNums;
}
