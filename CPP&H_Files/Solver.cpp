/**
 * @file Solver.cpp
 * @brief Implementation of the Solver class
 */

#include "Solver.h"
#include <QDebug>
#include <cstdlib>
#include <ctime>

/**
 * Constructor for Solver
 * Initializes iteration limits and random seed
 */
Solver::Solver(QObject *parent) : QObject(parent), m_maxIterations(2000000), m_currentIterations(0)
{
    // Initialize random seed for consistent random number generation
    std::srand(static_cast<unsigned int>(std::time(nullptr)));
}

/**
 * Solves a given Sudoku puzzle
 * 
 * @param qmlGrid Current state of the puzzle grid
 */
void Solver::solvePuzzle(QVariantList qmlGrid)
{
    // Reset iteration counter for each new puzzle
    m_currentIterations = 0;
    
    // Convert QML grid to C++ grid
    Grid grid(9, std::vector<int>(9));
    for (int i = 0; i < 9; ++i) {
        QVariantList row = qmlGrid[i].toList();
        for (int j = 0; j < 9; ++j) {
            grid[i][j] = row[j].toInt();
        }
    }

    // Create a copy of the grid to solve
    Grid solved = grid;
    bool solvable = solveSudoku(solved);

    // Convert solution back to QML format
    QVariantList qmlSolution;
    if (solvable) {
        for (const auto &row : solved) {
            QVariantList qmlRow;
            for (int cell : row) {
                qmlRow.append(cell);
            }
            qmlSolution.append(QVariant(qmlRow));
        }
    }
    
    // Signal the result back to QML
    emit sudokuSolved(solvable, qmlSolution);
}

/**
 * Solves a Sudoku puzzle using backtracking algorithm
 * Includes iteration limit to prevent excessive computation
 * 
 * @param grid Grid to solve
 * @return true if the puzzle was solved, false otherwise
 */
bool Solver::solveSudoku(Grid &grid)
{
    // Check if we've exceeded the maximum number of iterations
    if (m_currentIterations++ > m_maxIterations) {
        return false; // Prevent infinite recursion or excessive computation
    }

    // Find an empty cell
    for (int row = 0; row < 9; ++row) {
        for (int col = 0; col < 9; ++col) {
            if (grid[row][col] == 0) {
                // Try each number 1-9
                for (int num = 1; num <= 9; ++num) {
                    if (isValid(grid, row, col, num)) {
                        // Place the number if valid
                        grid[row][col] = num;
                        
                        // Recursively solve the rest of the grid
                        if (solveSudoku(grid)) {
                            return true;
                        }
                        
                        // If we get here, this number didn't work
                        grid[row][col] = 0; // Backtrack
                    }
                }
                // No valid number found for this cell
                return false;
            }
        }
    }
    
    // All cells filled successfully
    return true;
}

/**
 * Checks if a number is valid at a specific position
 * 
 * @param grid Grid to check
 * @param row Row index (0-8)
 * @param col Column index (0-8)
 * @param num Number to check (1-9)
 * @return true if the number is valid, false otherwise
 */
bool Solver::isValid(const Grid &grid, int row, int col, int num)
{
    // Check row for duplicates
    for (int x = 0; x < 9; ++x) {
        if (grid[row][x] == num) {
            return false;
        }
    }

    // Check column for duplicates
    for (int x = 0; x < 9; ++x) {
        if (grid[x][col] == num) {
            return false;
        }
    }

    // Check 3x3 box for duplicates
    int startRow = row - row % 3;
    int startCol = col - col % 3;
    for (int i = 0; i < 3; ++i) {
        for (int j = 0; j < 3; ++j) {
            if (grid[i + startRow][j + startCol] == num) {
                return false;
            }
        }
    }
    
    // No duplicates found, number is valid
    return true;
}