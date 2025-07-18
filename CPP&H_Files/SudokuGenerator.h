/**
 * @file SudokuGenerator.h
 * @brief Header file for the SudokuGenerator class which handles Sudoku puzzle generation and validation
 * 
 * This class is responsible for:
 * - Generating valid Sudoku puzzles with varying difficulty levels
 * - Validating user inputs against the solution
 * - Checking if a puzzle is complete and correct
 * - Saving completed puzzles to a history file
 */

#ifndef SUDOKUGENERATOR_H
#define SUDOKUGENERATOR_H

#include <QObject>
#include <QVariantList>
#include <vector>

/**
 * @class SudokuGenerator
 * @brief Generates and validates Sudoku puzzles
 * 
 * The SudokuGenerator class provides functionality to create Sudoku puzzles,
 * validate user inputs, and check if a puzzle has been solved correctly.
 * It also handles saving completed puzzles to a history file.
 */
class SudokuGenerator : public QObject
{
    Q_OBJECT
public:
    /**
     * @brief Constructor for SudokuGenerator
     * @param parent Parent QObject (default: nullptr)
     */
    explicit SudokuGenerator(QObject *parent = nullptr);

    /**
     * @brief Generates a new Sudoku puzzle
     * @param difficulty Difficulty level (1: Easy, 2: Medium, 3: Hard)
     * @return QVariantList containing the generated puzzle
     */
    Q_INVOKABLE QVariantList generateSudoku(int difficulty);

    /**
     * @brief Checks if a number is valid at a specific position
     * @param row Row index (0-8)
     * @param col Column index (0-8)
     * @param num Number to check (1-9)
     * @return true if the number matches the solution, false otherwise
     */
    Q_INVOKABLE bool checkNumber(int row, int col, int num);
    
    /**
     * @brief Checks if the current puzzle state is correct and complete
     * @param currentGrid Current state of the puzzle grid
     */
    Q_INVOKABLE void checkPuzzle(QVariantList currentGrid);
    
    /**
     * @brief Solves a given puzzle
     * @param grid Current state of the puzzle grid
     */
    Q_INVOKABLE void solvePuzzle(QVariantList grid);
    
    /**
     * @brief Saves a completed puzzle to the history file
     * @param grid Completed puzzle grid
     * @param time Time taken to complete the puzzle (in seconds)
     * @param difficulty Difficulty level of the puzzle
     */
    Q_INVOKABLE void savePuzzle(QVariantList grid, int time, int difficulty);

signals:
    /**
     * @brief Signal emitted when a new puzzle is generated
     * @param puzzle The generated puzzle
     */
    void sudokuGenerated(QVariantList puzzle);
    
    /**
     * @brief Signal emitted when a puzzle is solved
     * @param success Whether the puzzle was successfully solved
     * @param solution The solution grid
     */
    void sudokuSolved(bool success, QVariantList solution);
    
    /**
     * @brief Signal emitted when a puzzle is checked
     * @param status Status code: 1 = correct, 0 = incorrect, -1 = incomplete
     */
    void puzzleChecked(int status);

private:
    /** @brief Type alias for a 2D grid of integers */
    using Grid = std::vector<std::vector<int>>;
    
    /** @brief Stores the solved grid for validation */
    Grid solvedGrid;
    
    /**
     * @brief Creates an empty 9x9 grid
     * @return Empty grid filled with zeros
     */
    Grid generateEmptyGrid();
    
    /**
     * @brief Fills a grid with a valid Sudoku solution
     * @param grid Grid to fill
     */
    void fillGrid(Grid &grid);
    
    /**
     * @brief Solves a Sudoku puzzle using backtracking
     * @param grid Grid to solve
     * @return true if the puzzle was solved, false otherwise
     */
    bool solveSudoku(Grid &grid);
    
    /**
     * @brief Checks if a number is valid at a specific position
     * @param grid Grid to check
     * @param row Row index (0-8)
     * @param col Column index (0-8)
     * @param num Number to check (1-9)
     * @return true if the number is valid, false otherwise
     */
    bool isValid(const Grid &grid, int row, int col, int num);
    
    /**
     * @brief Removes cells from a grid to create a puzzle
     * @param grid Grid to modify
     * @param count Number of cells to remove
     */
    void removeCells(Grid &grid, int count);
};

#endif // SUDOKUGENERATOR_H