#ifndef SOLVER_H
#define SOLVER_H

#include <QObject>
#include <QVariantList>
#include <vector>

class Solver : public QObject
{
    Q_OBJECT
public:
    explicit Solver(QObject *parent = nullptr);

    Q_INVOKABLE void solvePuzzle(QVariantList grid);

signals:
    void sudokuSolved(bool success, QVariantList solution);

private:
    using Grid = std::vector<std::vector<int>>;
    bool solveSudoku(Grid &grid);
    bool isValid(const Grid &grid, int row, int col, int num);
};

#endif // SOLVER_H
