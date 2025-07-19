#ifndef SOLVER_H
#define SOLVER_H

#include <QObject>
#include <QVariantList>
#include <vector>
#include <array>
#include <bitset>

/**
 * @brief High-performance Sudoku solver with backtracking algorithm
 * 
 * This class provides an efficient Sudoku solving implementation with support
 * for standard 9x9 grids and optional diagonal constraints. Uses optimized
 * constraint checking and early termination for maximum performance.
 */
class Solver : public QObject {
    Q_OBJECT

public:
    explicit Solver(QObject *parent = nullptr);
    
    // Type aliases for better code readability
    using Grid = std::vector<std::vector<int>>;
    using BitSet = std::bitset<10>; // Index 0 unused, 1-9 for digits
    
    /**
     * @brief Solves a Sudoku puzzle from QML interface
     * @param qmlGrid 9x9 grid as QVariantList where 0 represents empty cells
     */
    Q_INVOKABLE void solvePuzzle(QVariantList qmlGrid);
    
    /**
     * @brief Enable/disable diagonal constraint checking (X-Sudoku variant)
     * @param enabled True to check main diagonals for uniqueness
     */
    Q_INVOKABLE void setCheckDiagonal(bool enabled);
    
    /**
     * @brief Set maximum iterations to prevent infinite loops
     * @param maxIter Maximum number of recursive calls allowed
     */
    Q_INVOKABLE void setMaxIterations(int maxIter);

signals:
    /**
     * @brief Emitted when solving is complete
     * @param solvable True if puzzle has a valid solution
     * @param solution Complete 9x9 grid solution (empty if unsolvable)
     */
    void sudokuSolved(bool solvable, QVariantList solution);

private:
    /**
     * @brief Core recursive backtracking solver with optimizations
     * @param grid Reference to the puzzle grid (modified in-place)
     * @return True if puzzle is solvable, false otherwise
     */
    bool solveSudoku(Grid &grid);
    
    /**
     * @brief Optimized constraint validation using bitsets
     * @param grid Current puzzle state
     * @param row Target row (0-8)
     * @param col Target column (0-8)  
     * @param num Number to validate (1-9)
     * @return True if placement is valid according to Sudoku rules
     */
    bool isValid(const Grid &grid, int row, int col, int num) const;
    
    /**
     * @brief Validates initial puzzle state for conflicts
     * @param grid Initial puzzle grid
     * @return True if initial state is valid, false if conflicts exist
     */
    bool isInitialGridValid(const Grid &grid);
    
    /**
     * @brief Find next empty cell using optimized search strategy
     * @param grid Current puzzle state
     * @param row Reference to store found row
     * @param col Reference to store found column
     * @return True if empty cell found, false if grid is complete
     */
    bool findEmptyCell(const Grid &grid, int &row, int &col) const;
    
    /**
     * @brief Get valid numbers for a specific cell position
     * @param grid Current puzzle state
     * @param row Target row
     * @param col Target column
     * @return Vector of valid numbers (1-9) for the position
     */
    std::vector<int> getValidNumbers(const Grid &grid, int row, int col) const;

    // Configuration and state tracking
    int m_maxIterations;        ///< Maximum recursive calls allowed
    mutable int m_currentIterations; ///< Current iteration count
    bool m_checkDiagonal;       ///< Enable diagonal constraint checking
    
    // Performance optimization constants
    static constexpr int GRID_SIZE = 9;
    static constexpr int BOX_SIZE = 3;
    static constexpr int MIN_NUM = 1;
    static constexpr int MAX_NUM = 9;
};

#endif // SOLVER_H
