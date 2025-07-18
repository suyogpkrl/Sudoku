/**
 * @file HistoryRead.cpp
 * @brief Implementation of the HistoryRead class
 */

#include "HistoryRead.h"
#include <QFile>
#include <QTextStream>
#include <QStandardPaths>
#include <QDir>
#include <QDebug>
#include <string>
#include <vector>
#include <fstream>

/**
 * Constructor for HistoryRead
 */
HistoryRead::HistoryRead(QObject *parent) : QObject(parent)
{
    // Constructor (no initialization needed)
}

/**
 * Retrieves the puzzle history from the history file
 * 
 * @return QVariantList containing all puzzle entries
 */
QVariantList HistoryRead::getHistory()
{
    // Container for history entries
    QVariantList historyList;
    
    // Get the path to the history file
    QString path = QStandardPaths::writableLocation(QStandardPaths::DocumentsLocation);
    QString filePath = path + "/SudokuPuzzles/solved_puzzles_history.txt";
    QFile file(filePath);

    // Check if the file exists
    if (!file.exists()) {
        qDebug() << "History file does not exist:" << filePath;
        return historyList;
    }

    // Read the file
    if (file.open(QIODevice::ReadOnly | QIODevice::Text)) {
        // Read all lines into memory
        QTextStream in(&file);
        QStringList lines;
        while (!in.atEnd()) {
            lines << in.readLine();
        }
        file.close();

        // Parse each puzzle entry
        int i = 0;
        while (i < lines.size()) {
            if (lines[i].trimmed() == "--- Puzzle Entry ---") {
                historyList.append(parsePuzzleEntry(lines, i));
            } else {
                i++; // Skip lines that are not puzzle entries
            }
        }
    } else {
        qDebug() << "Could not open history file:" << filePath;
    }
    
    return historyList;
}

/**
 * Parses a single puzzle entry from the history file
 * 
 * @param lines All lines from the history file
 * @param startIndex Index of the current line (updated during parsing)
 * @return QVariantMap containing the parsed puzzle entry
 */
QVariantMap HistoryRead::parsePuzzleEntry(const QStringList &lines, int &startIndex)
{
    // Create a map to store puzzle entry data
    QVariantMap entry;
    int time = 0;
    QString date;
    int difficulty = 0;
    QVariantList grid;

    // Skip the entry header line
    startIndex++;

    // Parse date
    if (startIndex < lines.size() && lines[startIndex].startsWith("Date: ")) {
        QString prefix = "Date: ";
        date = lines[startIndex].mid(lines[startIndex].indexOf(prefix) + prefix.length()).trimmed();
        startIndex++;
    }

    // Parse completion time
    if (startIndex < lines.size() && lines[startIndex].startsWith("Completion Time (seconds): ")) {
        QString prefix = "Completion Time (seconds): ";
        time = lines[startIndex].mid(lines[startIndex].indexOf(prefix) + prefix.length()).trimmed().toInt();
        startIndex++;
    }

    // Parse difficulty
    if (startIndex < lines.size() && lines[startIndex].startsWith("Difficulty: ")) {
        QString prefix = "Difficulty: ";
        difficulty = lines[startIndex].mid(lines[startIndex].indexOf(prefix) + prefix.length()).trimmed().toInt();
        startIndex++;
    }

    // Skip the "Puzzle:" line
    if (startIndex < lines.size() && lines[startIndex].trimmed() == "Puzzle:") {
        startIndex++;
    }

    // Parse the puzzle grid
    for (int row = 0; row < 9; ++row) {
        if (startIndex < lines.size()) {
            QVariantList qmlRow;
            QStringList cells = lines[startIndex].trimmed().split(" ", Qt::SkipEmptyParts);
            for (const QString &cell : cells) {
                qmlRow.append(cell.toInt());
            }
            grid.append(qmlRow);
            startIndex++;
        } else {
            // Incomplete puzzle entry, break
            break;
        }
    }

    // Store parsed data in the map
    entry["date"] = date;
    entry["time"] = time;
    entry["difficulty"] = difficulty;
    entry["grid"] = grid;
    
    return entry;
}