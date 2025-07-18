/**
 * @file main.cpp
 * @brief Main entry point for the Sudoku application
 * 
 * This file initializes the Qt application, registers C++ classes with QML,
 * and loads the main QML interface.
 */

#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include "SudokuGenerator.h"
#include "Solver.h"
#include "HistoryRead.h"

int main(int argc, char *argv[])
{
    // Enable high DPI scaling for Qt versions before 6.0
#if QT_VERSION < QT_VERSION_CHECK(6, 0, 0)
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
#endif

    // Create the application instance
    QGuiApplication app(argc, argv);
    
    // Create the QML engine
    QQmlApplicationEngine engine;
    
    // Register C++ classes with QML
    qmlRegisterType<SudokuGenerator>("com.sudoku.generator", 1, 0, "SudokuGenerator");
    qmlRegisterType<Solver>("com.sudoku.solver", 1, 0, "Solver");
    qmlRegisterType<HistoryRead>("com.sudoku.history", 1, 0, "HistoryRead");
    
    // Load the main QML file
    const QUrl url(QStringLiteral("qrc:/main.qml"));
    
    // Connect to the objectCreated signal to handle errors
    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreated,
        &app,
        [url](QObject *obj, const QUrl &objUrl) {
            if (!obj && url == objUrl)
                QCoreApplication::exit(-1);
        },
        Qt::QueuedConnection);
    
    // Load the QML file
    engine.load(url);
    
    // Start the application event loop
    return app.exec();
}