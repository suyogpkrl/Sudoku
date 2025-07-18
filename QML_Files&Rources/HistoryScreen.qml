/**
 * HistoryScreen.qml
 *
 * A screen that displays the history of completed Sudoku puzzles.
 * Uses the HistoryRead C++ class to retrieve puzzle history.
 */

import QtQuick 2.15
import QtQuick.Controls 2.15
import com.sudoku.history 1.0

Item {
    id: historyScreen
    width: parent.width
    height: parent.height

    // History reader component
    HistoryRead {
        id: historyReader
    }

    Text{
        id:noHistory
        text:"Solve atleast one puzzle"
        color: mainWindow.textMainColour
        font.pixelSize: 20
        visible: historyListView.count === 0
        anchors.centerIn: parent
    }

    // Screen title
    Text {
        id: historyTitle
        text: "History"
        anchors {
            top: parent.top
            topMargin: 60
            horizontalCenter: parent.horizontalCenter
        }
        font {
            pixelSize: 24
            bold: true
        }
        color: mainWindow.textMainColour
    }

    // Container for the history list
    Rectangle {
        id: listContainer
        anchors {
            top: historyTitle.bottom
            bottom: backButton.top
            topMargin: 20
            bottomMargin: 20
            horizontalCenter: parent.horizontalCenter
        }
        width: parent.width - 120
        color: "transparent"

        // List view of history entries
        ListView {
            id: historyListView
            anchors.fill: parent
            spacing: 20
            clip: true  // Important for performance with many items

            // Load history data only once when the component is created
            Component.onCompleted: {
                model = historyReader.getHistory();
            }

            // Invisible scrollbar for better performance
            ScrollBar.vertical: ScrollBar {
                policy: ScrollBar.AlwaysOff
                visible: false
                interactive: false
            }

            // History entry delegate
            delegate: ItemDelegate {
                width: historyListView.width
                height: 60

                // Entry background
                background: Rectangle {
                    border.width: 2
                    border.color: mainWindow.borderMainColour
                    color: "transparent"
                    radius: 5
                }

                // Entry content
                contentItem: Text {
                    // Format difficulty text once instead of using conditional operators in the binding
                    readonly property string difficultyText: {
                        switch(modelData.difficulty) {
                            case 1: return "Easy";
                            case 2: return "Medium";
                            case 3: return "Hard";
                            default: return "Unknown";
                        }
                    }

                    text: "Date: " + modelData.date + " - Time: " + modelData.time + "s (Difficulty: " + difficultyText + ")"
                    color: mainWindow.textMainColour
                    font.pixelSize: 16
                    elide: Text.ElideRight
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                    anchors.fill: parent
                    leftPadding: 20
                    rightPadding: 20
                }

                // Navigate to puzzle detail view when clicked
                onClicked: {
                    stackView.push("PuzzleHistoryView.qml", {
                        date: modelData.date,
                        time: modelData.time,
                        difficulty: modelData.difficulty,
                        gridString: JSON.stringify(modelData.grid)
                    })
                }
            }
        }
    }

    // Back button
    BackButton {
        id: backButton
        anchors {
            bottom: parent.bottom
            bottomMargin: Math.min(parent.width, parent.height) * 0.1
            right: parent.right
            rightMargin: 60
        }
        onClicked: stackView.pop()
    }
}
