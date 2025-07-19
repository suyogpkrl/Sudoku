#include "Solver.h"
#include <QDebug>

Solver::Solver(QObject *parent)
    : QObject(parent), m_maxIterations(1000000), m_currentIterations(0), m_checkDiagonal(false) {}

void Solver::setCheckDiagonal(bool enabled) {
    m_checkDiagonal = enabled;
}

void Solver::solvePuzzle(QVariantList qmlGrid) {
    m_currentIterations = 0;
    Grid grid(9, std::vector<int>(9));
    for (int i = 0; i < 9; ++i) {
        QVariantList row = qmlGrid[i].toList();
        for (int j = 0; j < 9; ++j) {
            grid[i][j] = row[j].toInt();
        }
    }

    if (!isInitialGridValid(grid)) {
        qDebug() << "Initial grid has conflicts.";
        emit sudokuSolved(false, QVariantList()); // invalid input
        return;
    }

    Grid solved = grid;
    bool solvable = solveSudoku(solved);

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

    emit sudokuSolved(solvable, qmlSolution);
}

bool Solver::solveSudoku(Grid &grid) {
    if (m_currentIterations++ > m_maxIterations) return false;

    for (int row = 0; row < 9; ++row) {
        for (int col = 0; col < 9; ++col) {
            if (grid[row][col] == 0) {
                for (int num = 1; num <= 9; ++num) {
                    if (isValid(grid, row, col, num)) {
                        grid[row][col] = num;
                        if (solveSudoku(grid)) return true;
                        grid[row][col] = 0; // backtrack
                    }
                }
                return false; // no number fits
            }
        }
    }
    return true; // puzzle solved
}

bool Solver::isValid(const Grid &grid, int row, int col, int num) {
    for (int x = 0; x < 9; ++x) {
        if (grid[row][x] == num || grid[x][col] == num)
            return false;
    }

    int startRow = row - row % 3;
    int startCol = col - col % 3;
    for (int i = 0; i < 3; ++i) {
        for (int j = 0; j < 3; ++j) {
            if (grid[startRow + i][startCol + j] == num)
                return false;
        }
    }

    if (m_checkDiagonal) {
        if (row == col) {
            for (int i = 0; i < 9; ++i) {
                if (grid[i][i] == num)
                    return false;
            }
        }
        if (row + col == 8) {
            for (int i = 0; i < 9; ++i) {
                if (grid[i][8 - i] == num)
                    return false;
            }
        }
    }

    return true;
}

bool Solver::isInitialGridValid(Grid &grid) {
    for (int row = 0; row < 9; ++row) {
        for (int col = 0; col < 9; ++col) {
            int val = grid[row][col];
            if (val != 0) {
                grid[row][col] = 0;
                if (!isValid(grid, row, col, val)) {
                    grid[row][col] = val;
                    return false;
                }
                grid[row][col] = val;
            }
        }
    }
    return true;
}
