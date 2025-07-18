/**
 * @file HistoryRead.h
 * @brief Header file for the HistoryRead class which reads puzzle history
 * 
 * This class is responsible for:
 * - Reading saved puzzle history from a file
 * - Parsing puzzle entries into a format usable by QML
 * - Providing access to historical puzzle data
 */

#ifndef HISTORYREAD_H
#define HISTORYREAD_H

#include <QObject>
#include <QVariantList>
#include <QVariantMap>
#include <QString>

/**
 * @class HistoryRead
 * @brief Reads and parses Sudoku puzzle history
 * 
 * The HistoryRead class provides functionality to read saved puzzle history
 * from a file and parse it into a format that can be used by the QML interface.
 */
class HistoryRead : public QObject
{
    Q_OBJECT
public:
    /**
     * @brief Constructor for HistoryRead
     * @param parent Parent QObject (default: nullptr)
     */
    explicit HistoryRead(QObject *parent = nullptr);

    /**
     * @brief Retrieves the puzzle history
     * @return QVariantList containing all puzzle entries
     */
    Q_INVOKABLE QVariantList getHistory();

private:
    /**
     * @brief Parses a single puzzle entry from the history file
     * @param lines All lines from the history file
     * @param startIndex Index of the current line (updated during parsing)
     * @return QVariantMap containing the parsed puzzle entry
     */
    QVariantMap parsePuzzleEntry(const QStringList &lines, int &startIndex);
};

#endif // HISTORYREAD_H