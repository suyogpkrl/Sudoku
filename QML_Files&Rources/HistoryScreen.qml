import QtQuick 2.15
import QtQuick.Controls 2.15
import com.sudoku.history 1.0

Item {
    id: historyScreen
    width: parent.width
    height: parent.height

    HistoryRead {
        id: historyReader
    }

    Text{
        id:historyTitle
        text: "History"
        anchors{
            top:parent.top
            topMargin: 60
            horizontalCenter: parent.horizontalCenter
        }
        font{
            pixelSize: 24
            bold: true
        }
        color: mainWindow.textMainColour
    }

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
        color: "transparent"  // Ensure the rectangle itself is transparent

        ListView {
            id: historyListView
            anchors.fill: parent
            spacing: 20
            clip: true  // Important for performance with many items
            model: historyReader.getHistory()
            // This enables scrolling but keeps the scrollbar invisible
                        ScrollBar.vertical: ScrollBar {
                            policy: ScrollBar.AlwaysOff
                            visible: false
                            interactive: false  // Prevents mouse interaction with the invisible bar
            }

            delegate: ItemDelegate {
                width: historyListView.width
                height: 60  // Fixed height as requested

                background: Rectangle {
                    border.width: 2
                    border.color: mainWindow.borderMainColour
                    color: "transparent"
                    radius: 5  // Optional: adds rounded corners
                }

                contentItem: Text {
                    text: "Date: " + modelData.date + " - Time: " + modelData.time + "s (Difficulty: " + (modelData.difficulty === 1 ? "Easy" : (modelData.difficulty === 2 ? "Medium" : "Hard")) + ")"
                    color: mainWindow.textMainColour
                    font.pixelSize: 16
                    elide: Text.ElideRight
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                    anchors.fill: parent
                    leftPadding: 20
                    rightPadding: 20
                }

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
