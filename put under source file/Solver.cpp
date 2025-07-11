#include "Solver.h"
#include <QDebug>

Solver::Solver(QObject *parent) : QObject(parent)
{

}

void Solver::solvePuzzle(QVariantList qmlGrid)
{
    Grid grid(9, std::vector<int>(9));
    for (int i = 0; i < 9; ++i) {
        QVariantList row = qmlGrid[i].toList();
        for (int j = 0; j < 9; ++j) {
            grid[i][j] = row[j].toInt();
        }
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

bool Solver::solveSudoku(Grid &grid)
{
    for (int row = 0; row < 9; ++row) {
        for (int col = 0; col < 9; ++col) {
            if (grid[row][col] == 0) {
                for (int num = 1; num <= 9; ++num) {
                    if (isValid(grid, row, col, num)) {
                        grid[row][col] = num;
                        if (solveSudoku(grid)) {
                            return true;
                        }
                        grid[row][col] = 0; // Backtrack
                    }
                }
                return false;
            }
        }
    }
    return true;
}

bool Solver::isValid(const Grid &grid, int row, int col, int num)
{
    // Check row
    for (int x = 0; x < 9; ++x) {
        if (grid[row][x] == num) {
            return false;
        }
    }

    // Check column
    for (int x = 0; x < 9; ++x) {
        if (grid[x][col] == num) {
            return false;
        }
    }

    // Check 3x3 box
    int startRow = row - row % 3;
    int startCol = col - col % 3;
    for (int i = 0; i < 3; ++i) {
        for (int j = 0; j < 3; ++j) {
            if (grid[i + startRow][j + startCol] == num) {
                return false;
            }
        }
    }
    return true;
}
