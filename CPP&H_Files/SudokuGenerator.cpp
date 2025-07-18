/**
 * @file SudokuGenerator.cpp
 * @brief Implementation of the SudokuGenerator class
 */

#include "SudokuGenerator.h"
#include <QDebug>
#include <QRandomGenerator>
#include <algorithm>
#include <random>
#include <QFile>
#include <QTextStream>
#include <QStandardPaths>
#include <QDir>
#include <QDateTime>
#include <cstdlib>
#include <ctime>

/**
 * Constructor for SudokuGenerator
 * Initializes random seed for puzzle generation
 */
SudokuGenerator::SudokuGenerator(QObject *parent) : QObject(parent)
{
    // Initialize random seed for consistent random number generation
    std::srand(static_cast<unsigned int>(std::time(nullptr)));
}

/**
 * Generates a new Sudoku puzzle with the specified difficulty
 * 
 * @param difficulty Difficulty level (1: Easy, 2: Medium, 3: Hard)
 * @return QVariantList containing the generated puzzle
 */
QVariantList SudokuGenerator::generateSudoku(int difficulty)
{
    // Create an empty grid and fill it with a valid solution
    Grid grid = generateEmptyGrid();
    fillGrid(grid);
    solvedGrid = grid; // Store the complete solution for later validation

    // Determine number of cells to remove based on difficulty
    int cellsToRemove = 0;
    switch (difficulty) {
        case 1: // Easy
            cellsToRemove = 30; // Approximately 1/3 of cells removed
            break;
        case 2: // Medium
            cellsToRemove = 45; // Half of cells removed
            break;
        case 3: // Hard
            cellsToRemove = 60; // 2/3 of cells removed
            break;
        default:
            cellsToRemove = 30; // Default to Easy if invalid difficulty
    }

    // Remove cells to create the puzzle
    removeCells(grid, cellsToRemove);

    // Convert the C++ grid to QML-compatible format
    QVariantList qmlGrid;
    for (const auto &row : grid) {
        QVariantList qmlRow;
        for (int cell : row) {
            qmlRow.append(cell);
        }
        qmlGrid.append(QVariant(qmlRow));
    }
    
    // Signal that a new puzzle has been generated
    emit sudokuGenerated(qmlGrid);
    return qmlGrid;
}

/**
 * Creates an empty 9x9 grid filled with zeros
 * 
 * @return Empty grid
 */
SudokuGenerator::Grid SudokuGenerator::generateEmptyGrid()
{
    // Create a 9x9 grid filled with zeros
    return Grid(9, std::vector<int>(9, 0));
}

/**
 * Fills a grid with a valid Sudoku solution
 * 
 * @param grid Grid to fill
 */
void SudokuGenerator::fillGrid(Grid &grid)
{
    // Fill the grid with a valid Sudoku solution using backtracking
    solveSudoku(grid);
}

/**
 * Solves a Sudoku puzzle using backtracking algorithm
 * Uses random number order to generate different solutions
 * 
 * @param grid Grid to solve
 * @return true if the puzzle was solved, false otherwise
 */
bool SudokuGenerator::solveSudoku(Grid &grid)
{
    // Find an empty cell
    for (int row = 0; row < 9; ++row) {
        for (int col = 0; col < 9; ++col) {
            if (grid[row][col] == 0) {
                // Try numbers 1-9 in random order for variety in generated puzzles
                std::vector<int> numbers = {1, 2, 3, 4, 5, 6, 7, 8, 9};
                
                // Use standard C++ random shuffle
                std::random_device rd;
                std::mt19937 g(rd());
                std::shuffle(numbers.begin(), numbers.end(), g);

                // Try each number
                for (int num : numbers) {
                    if (isValid(grid, row, col, num)) {
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
bool SudokuGenerator::isValid(const Grid &grid, int row, int col, int num)
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

/**
 * Removes cells from a grid to create a puzzle
 * 
 * @param grid Grid to modify
 * @param count Number of cells to remove
 */
void SudokuGenerator::removeCells(Grid &grid, int count)
{
    // Remove 'count' cells randomly from the grid
    int removed = 0;
    while (removed < count) {
        // Generate random row and column
        int row = QRandomGenerator::global()->bounded(9);
        int col = QRandomGenerator::global()->bounded(9);

        // If cell is not already empty, remove it
        if (grid[row][col] != 0) {
            grid[row][col] = 0;
            removed++;
        }
    }
}

/**
 * Checks if a number matches the solution at a specific position
 * 
 * @param row Row index (0-8)
 * @param col Column index (0-8)
 * @param num Number to check (1-9)
 * @return true if the number matches the solution, false otherwise
 */
bool SudokuGenerator::checkNumber(int row, int col, int num)
{
    // Validate row and column bounds
    if (row < 0 || row >= 9 || col < 0 || col >= 9) {
        return false;
    }
    
    // Check if the number matches the solution
    return solvedGrid[row][col] == num;
}

/**
 * Checks if the current puzzle state is correct and complete
 * 
 * @param qmlGrid Current state of the puzzle grid
 */
void SudokuGenerator::checkPuzzle(QVariantList qmlGrid)
{
    // First check if the puzzle is complete (no empty cells)
    bool isFull = true;
    for (int i = 0; i < 9; ++i) {
        QVariantList row = qmlGrid[i].toList();
        for (int j = 0; j < 9; ++j) {
            if (row[j].toInt() == 0) {
                isFull = false;
                break;
            }
        }
        if (!isFull) {
            break;
        }
    }

    // If puzzle is incomplete, notify UI
    if (!isFull) {
        emit puzzleChecked(-1); // Incomplete
        return;
    }

    // Check if the puzzle matches the solution
    bool isCorrect = true;
    for (int i = 0; i < 9; ++i) {
        QVariantList row = qmlGrid[i].toList();
        for (int j = 0; j < 9; ++j) {
            if (row[j].toInt() != solvedGrid[i][j]) {
                isCorrect = false;
                break;
            }
        }
        if (!isCorrect) {
            break;
        }
    }

    // Notify UI of the result
    if (isCorrect) {
        emit puzzleChecked(1); // Correct
    } else {
        emit puzzleChecked(0); // Incorrect
    }
}

/**
 * Solves a given puzzle
 * 
 * @param qmlGrid Current state of the puzzle grid
 */
void SudokuGenerator::solvePuzzle(QVariantList qmlGrid)
{
    // Convert QML grid to C++ grid
    Grid grid(9, std::vector<int>(9));
    for (int i = 0; i < 9; ++i) {
        QVariantList row = qmlGrid[i].toList();
        for (int j = 0; j < 9; ++j) {
            grid[i][j] = row[j].toInt();
        }
    }

    // Solve the puzzle
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
 * Saves a completed puzzle to the history file
 * 
 * @param qmlGrid Completed puzzle grid
 * @param time Time taken to complete the puzzle (in seconds)
 * @param difficulty Difficulty level of the puzzle
 */
void SudokuGenerator::savePuzzle(QVariantList qmlGrid, int time, int difficulty)
{
    // Get the documents directory path
    QString path = QStandardPaths::writableLocation(QStandardPaths::DocumentsLocation);
    
    // Create directory if it doesn't exist
    QDir dir(path);
    if (!dir.exists("SudokuPuzzles")) {
        dir.mkdir("SudokuPuzzles");
    }
    
    // Open file for appending
    QString filePath = path + "/SudokuPuzzles/solved_puzzles_history.txt";
    QFile file(filePath);
    if (file.open(QIODevice::Append | QIODevice::Text)) {
        QTextStream out(&file);
        
        // Write puzzle metadata
        out << "--- Puzzle Entry ---\n";
        out << "Date: " << QDateTime::currentDateTime().toString("yyyy-MM-dd hh:mm:ss") << "\n";
        out << "Completion Time (seconds): " << time << "\n";
        out << "Difficulty: " << difficulty << "\n";
        out << "Puzzle:\n";
        
        // Write puzzle grid
        for (int i = 0; i < 9; ++i) {
            QVariantList row = qmlGrid[i].toList();
            for (int j = 0; j < 9; ++j) {
                out << row[j].toInt() << " ";
            }
            out << "\n";
        }
        file.close();
    }
}