#include "SudokuGenerator.h"
#include <QDebug>
#include <QRandomGenerator>
#include <algorithm>
#include <random>

SudokuGenerator::SudokuGenerator(QObject *parent) : QObject(parent)
{
}

QVariantList SudokuGenerator::generateSudoku(int difficulty)
{
    Grid grid = generateEmptyGrid();
    fillGrid(grid);
    solvedGrid = grid; // Store the complete solution

    int cellsToRemove = 0;
    if (difficulty == 1) { // Easy
        cellsToRemove = 40;
    } else if (difficulty == 2) { // Medium
        cellsToRemove = 50;
    } else { // Hard
        cellsToRemove = 60;
    }

    removeCells(grid, cellsToRemove);

    QVariantList qmlGrid;
    for (const auto &row : grid) {
        QVariantList qmlRow;
        for (int cell : row) {
            qmlRow.append(cell);
        }
        qmlGrid.append(QVariant(qmlRow));
    }

    emit sudokuGenerated(qmlGrid);
    return qmlGrid;
}

SudokuGenerator::Grid SudokuGenerator::generateEmptyGrid()
{
    return Grid(9, std::vector<int>(9, 0));
}

void SudokuGenerator::fillGrid(Grid &grid)
{
    solveSudoku(grid);
}

bool SudokuGenerator::solveSudoku(Grid &grid)
{
    for (int row = 0; row < 9; ++row) {
        for (int col = 0; col < 9; ++col) {
            if (grid[row][col] == 0) {
                std::vector<int> numbers = {1, 2, 3, 4, 5, 6, 7, 8, 9};
                std::random_device rd;
                std::mt19937 g(rd());
                std::shuffle(numbers.begin(), numbers.end(), g);

                for (int num : numbers) {
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

bool SudokuGenerator::isValid(const Grid &grid, int row, int col, int num)
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

void SudokuGenerator::removeCells(Grid &grid, int count)
{
    int removed = 0;
    while (removed < count) {
        int row = QRandomGenerator::global()->bounded(9);
        int col = QRandomGenerator::global()->bounded(9);

        if (grid[row][col] != 0) {
            grid[row][col] = 0;
            removed++;
        }
    }
}

bool SudokuGenerator::checkNumber(int row, int col, int num)
{
    if (row < 0 || row >= 9 || col < 0 || col >= 9) {
        return false;
    }
    return solvedGrid[row][col] == num;
}

void SudokuGenerator::solvePuzzle(QVariantList qmlGrid)
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