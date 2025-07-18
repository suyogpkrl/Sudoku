#include "HistoryRead.h"
#include <QFile>
#include <QTextStream>
#include <QStandardPaths>
#include <QDir>
#include <QDebug>

HistoryRead::HistoryRead(QObject *parent) : QObject(parent)
{
}

QVariantList HistoryRead::getHistory()
{
    QVariantList historyList;
    QString path = QStandardPaths::writableLocation(QStandardPaths::DocumentsLocation);
    QString filePath = path + "/SudokuPuzzles/solved_puzzles_history.txt";
    QFile file(filePath);

    if (!file.exists()) {
        qDebug() << "History file does not exist:" << filePath;
        return historyList;
    }

    if (file.open(QIODevice::ReadOnly | QIODevice::Text)) {
        QTextStream in(&file);
        QStringList lines;
        while (!in.atEnd()) {
            lines << in.readLine();
        }
        file.close();

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

QVariantMap HistoryRead::parsePuzzleEntry(const QStringList &lines, int &startIndex)
{
    QVariantMap entry;
    int time = 0;
    QString date;
    int difficulty = 0; // Add difficulty variable
    QVariantList grid;

    // Skip "--- Puzzle Entry ---"
    startIndex++;

    // Read Date
    if (startIndex < lines.size() && lines[startIndex].startsWith("Date: ")) {
        QString prefix = "Date: ";
        date = lines[startIndex].mid(lines[startIndex].indexOf(prefix) + prefix.length()).trimmed();
        startIndex++;
    }

    // Read Completion Time
    if (startIndex < lines.size() && lines[startIndex].startsWith("Completion Time (seconds): ")) {
        QString prefix = "Completion Time (seconds): ";
        time = lines[startIndex].mid(lines[startIndex].indexOf(prefix) + prefix.length()).trimmed().toInt();
        startIndex++;
    }

    // Read Difficulty
    if (startIndex < lines.size() && lines[startIndex].startsWith("Difficulty: ")) {
        QString prefix = "Difficulty: ";
        difficulty = lines[startIndex].mid(lines[startIndex].indexOf(prefix) + prefix.length()).trimmed().toInt();
        startIndex++;
    }

    // Read "Puzzle:"
    if (startIndex < lines.size() && lines[startIndex].trimmed() == "Puzzle:") {
        startIndex++;
    }

    // Read Grid
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

    entry["date"] = date;
    entry["time"] = time;
    entry["difficulty"] = difficulty; // Add difficulty to entry
    entry["grid"] = grid;
    return entry;
}
