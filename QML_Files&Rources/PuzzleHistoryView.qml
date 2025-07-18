/**
 * PuzzleHistoryView.qml
 * 
 * A screen that displays details of a completed Sudoku puzzle from history.
 * Shows the puzzle grid, completion time, date, and difficulty.
 */

import QtQuick 2.15
import QtQuick.Controls 2.15

Item {
    id: puzzleHistoryView
    width: parent.width
    height: parent.height

    // Properties passed from HistoryScreen
    property string date: ""
    property int time: 0
    property int difficulty: 0
    property string gridString: ""
    property var grid: []
    
    // Computed property for difficulty text
    readonly property string difficultyText: {
        switch(difficulty) {
            case 1: return "Easy";
            case 2: return "Medium";
            case 3: return "Hard";
            default: return "Unknown";
        }
    }

    // Parse the grid data when the component is created
    Component.onCompleted: {
        if (gridString) {
            grid = JSON.parse(gridString);
        }
    }

    // Screen title
    Rectangle {
        id: historyTitle
        height: 50
        color: "transparent"
        anchors {
            top: borderControl.top
            right: backButtonOption.right
            left: borderControl.right
            leftMargin: 20
        }
        
        Text {
            text: "History"
            anchors.centerIn: parent
            font {
                pixelSize: 24
                bold: true
            }
            color: mainWindow.textMainColour
        }
    }

    // Puzzle grid display
    Rectangle {
        id: borderControl
        width: Math.min(parent.width, parent.height) * 0.8
        height: width
        color: "transparent"
        border.width: 2
        border.color: mainWindow.borderMainColour
        anchors {
            left: parent.left
            leftMargin: 60
            verticalCenter: parent.verticalCenter
        }

        Grid {
            id: sudokuGrid
            columns: 9
            rows: 9
            spacing: 0
            anchors.fill: parent

            // Create cells for each number in the grid
            Repeater {
                model: 81 // Fixed size for 9x9 grid
                
                Rectangle {
                    width: sudokuGrid.width / 9
                    height: sudokuGrid.height / 9
                    color: "transparent"
                    border.width: 1
                    border.color: mainWindow.borderMainColour
                    
                    // Calculate row and column from index
                    readonly property int row: Math.floor(index / 9)
                    readonly property int col: index % 9
                    readonly property int value: {
                        if (puzzleHistoryView.grid && 
                            puzzleHistoryView.grid[row] && 
                            puzzleHistoryView.grid[row][col] !== undefined) {
                            return puzzleHistoryView.grid[row][col];
                        }
                        return 0;
                    }

                    Text {
                        text: value > 0 ? value : ""
                        anchors.centerIn: parent
                        color: mainWindow.textMainColour
                        font.pixelSize: 20
                    }
                }
            }
        }
    }

    // Puzzle details column
    Column {
        spacing: 10
        anchors {
            right: backButtonOption.right
            top: historyTitle.bottom
            topMargin: 10
            left: borderControl.right
            leftMargin: 20
        }

        // Time display
        Rectangle {
            anchors.right: parent.right
            border.width: 2
            border.color: mainWindow.borderMainColour
            radius: 5
            height: 50
            width: parent.width
            color: "transparent"
            
            Text {
                text: "Time: " + puzzleHistoryView.time + " seconds"
                color: mainWindow.textMainColour
                font.pixelSize: 20
                anchors {
                    verticalCenter: parent.verticalCenter
                    left: parent.left
                    leftMargin: 10
                }
                wrapMode: Text.WordWrap
            }
        }
        
        // Date display
        Rectangle {
            anchors.right: parent.right
            border.width: 2
            border.color: mainWindow.borderMainColour
            radius: 5
            height: 90
            width: parent.width
            color: "transparent"
            
            Text {
                text: "Date: " + puzzleHistoryView.date
                color: mainWindow.textMainColour
                font.pixelSize: 20
                width: parent.width - 20
                anchors.centerIn: parent
                wrapMode: Text.WordWrap
                lineHeight: 1
            }
        }

        // Difficulty display
        Rectangle {
            anchors.right: parent.right
            border.width: 2
            border.color: mainWindow.borderMainColour
            radius: 5
            height: 50
            width: parent.width
            color: "transparent"
            
            Text {
                text: "Difficulty: " + puzzleHistoryView.difficultyText
                color: mainWindow.textMainColour
                font.pixelSize: 20
                anchors {
                    verticalCenter: parent.verticalCenter
                    left: parent.left
                    leftMargin: 10
                }
                wrapMode: Text.WordWrap
            }
        }
    }

    // Back button
    BackButton {
        id: backButtonOption
        anchors {
            bottom: borderControl.bottom
            right: parent.right
            rightMargin: 60
        }
        onClicked: {
            stackView.pop()
        }
    }
}