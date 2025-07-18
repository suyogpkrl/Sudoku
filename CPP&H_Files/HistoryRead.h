#ifndef HISTORYREAD_H
#define HISTORYREAD_H

#include <QObject>
#include <QVariantList>
#include <QVariantMap>
#include <QString>

class HistoryRead : public QObject
{
    Q_OBJECT
public:
    explicit HistoryRead(QObject *parent = nullptr);

    Q_INVOKABLE QVariantList getHistory();

private:
    QVariantMap parsePuzzleEntry(const QStringList &lines, int &startIndex);
};

#endif // HISTORYREAD_H
