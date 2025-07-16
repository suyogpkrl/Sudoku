#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include "SudokuGenerator.h"
#include "Solver.h"
#include "HistoryRead.h"

int main(int argc, char *argv[])
{
#if QT_VERSION < QT_VERSION_CHECK(6, 0, 0)
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
#endif
    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;
    qmlRegisterType<SudokuGenerator>("com.sudoku.generator", 1, 0, "SudokuGenerator");
    qmlRegisterType<Solver>("com.sudoku.solver", 1, 0, "Solver");
    qmlRegisterType<HistoryRead>("com.sudoku.history", 1, 0, "HistoryRead");

    const QUrl url(QStringLiteral("qrc:/main.qml"));
    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreated,
        &app,
        [url](QObject *obj, const QUrl &objUrl) {
            if (!obj && url == objUrl)
                QCoreApplication::exit(-1);
        },
        Qt::QueuedConnection);
    engine.load(url);

    return app.exec();
}
