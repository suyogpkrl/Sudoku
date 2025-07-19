#ifndef SOLVER_H
#define SOLVER_H

#include <QObject>
#include <QVariantList>
#include <vector>

class Solver : public QObject {
    Q_OBJECT

public:
    explicit Solver(QObject *parent = nullptr);
    using Grid = std::vector<std::vector<int>>;

    Q_INVOKABLE void solvePuzzle(QVariantList qmlGrid);
    void setCheckDiagonal(bool enabled);

signals:
    void sudokuSolved(bool solvable, QVariantList solution);

private:
    bool solveSudoku(Grid &grid);
    bool isValid(const Grid &grid, int row, int col, int num);
    bool isInitialGridValid(Grid &grid);

    int m_maxIterations;
    int m_currentIterations;
    bool m_checkDiagonal;
};

#endif // SOLVER_H