
#ifndef SUDOKUGENERATOR_H
#define SUDOKUGENERATOR_H

#include <QObject>
#include <QVariantList>
#include <vector>

class SudokuGenerator : public QObject
{
    Q_OBJECT
public:
    explicit SudokuGenerator(QObject *parent = nullptr);

    Q_INVOKABLE QVariantList generateSudoku(int difficulty);

    Q_INVOKABLE bool checkNumber(int row, int col, int num);
    Q_INVOKABLE void checkPuzzle(QVariantList currentGrid);
    Q_INVOKABLE void solvePuzzle(QVariantList grid);
    Q_INVOKABLE void savePuzzle(QVariantList grid, int time, int difficulty);

signals:
    void sudokuGenerated(QVariantList puzzle);
    void sudokuSolved(bool success, QVariantList solution);
    void puzzleChecked(int status);

private:
    using Grid = std::vector<std::vector<int>>;
    Grid solvedGrid;
    Grid generateEmptyGrid();
    void fillGrid(Grid &grid);
    bool solveSudoku(Grid &grid);
    bool isValid(const Grid &grid, int row, int col, int num);
    void removeCells(Grid &grid, int count);
};

#endif // SUDOKUGENERATOR_H
