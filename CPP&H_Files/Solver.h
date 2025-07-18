/**
 * @file Solver.h
 * @brief Header file for the Solver class which solves Sudoku puzzles
 * 
 * This class is responsible for:
 * - Solving Sudoku puzzles using a backtracking algorithm
 * - Converting between QML and C++ data structures
 * - Limiting computation to prevent excessive resource usage
 */

#ifndef SOLVER_H
#define SOLVER_H

#include <QObject>
#include <QVariantList>
#include <vector>

/**
 * @class Solver
 * @brief Solves Sudoku puzzles using a backtracking algorithm
 * 
 * The Solver class provides functionality to solve Sudoku puzzles
 * and return the solution to the QML interface.
 */
class Solver : public QObject
{
    Q_OBJECT
public:
    /**
     * @brief Constructor for Solver
     * @param parent Parent QObject (default: nullptr)
     */
    explicit Solver(QObject *parent = nullptr);

    /**
     * @brief Solves a given Sudoku puzzle
     * @param grid Current state of the puzzle grid
     */
    Q_INVOKABLE void solvePuzzle(QVariantList grid);

signals:
    /**
     * @brief Signal emitted when a puzzle is solved
     * @param success Whether the puzzle was successfully solved
     * @param solution The solution grid
     */
    void sudokuSolved(bool success, QVariantList solution);

private:
    /** @brief Type alias for a 2D grid of integers */
    using Grid = std::vector<std::vector<int>>;
    
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
    
    /** @brief Maximum number of iterations to prevent infinite loops */
    int m_maxIterations;
    
    /** @brief Current iteration count */
    int m_currentIterations;
};

#endif // SOLVER_H