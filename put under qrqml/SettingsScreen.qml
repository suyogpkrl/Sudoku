import QtQuick
import QtQuick.Controls
import QtQuick.Window
import QtMultimedia

Item {
    id: settingScreen
    width: parent.width
    height: parent.height

    property int screenState: mainWindow.visibility
    property bool playTuneOnSolve: true // Default to true

    Column {
        id: settingsColumn
        width: parent.width
        anchors.top: parent.top
        anchors.topMargin: parent.height * 0.1
        spacing: 20

        // Screen Mode Setting
        Row {
            width: parent.width
            height: childrenRect.height

            Text {
                id: screenModeLabel
                text: "Screen Mode:"
                color: "#007BFF"
                font.pixelSize: 20
                anchors.left: parent.left
                anchors.leftMargin: parent.width * 0.2
                verticalAlignment: Text.AlignVCenter
            }

            Text {
                id: screenModeValue
                text: (screenState === Window.Maximized ? "Maximized" : (screenState === Window.FullScreen ? "Full Screen" : "Windowed"))
                color: "white"
                font.pixelSize: 20
                anchors.right: parent.right
                anchors.rightMargin: parent.width * 0.2
                verticalAlignment: Text.AlignVCenter

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                        if (mainWindow.visibility === Window.Maximized) {
                            mainWindow.showFullScreen();
                        } else if (mainWindow.visibility === Window.FullScreen) {
                            mainWindow.showNormal();
                        } else {
                            mainWindow.showMaximized();
                        }
                        screenState = mainWindow.visibility
                    }
                }
            }
        }

        // Play Tune on Solve Setting
        Row {
            width: parent.width
            height: childrenRect.height

            Text {
                text: "Play Tune on Solve:"
                color: "#007BFF"
                font.pixelSize: 20
                anchors.left: parent.left
                anchors.leftMargin: parent.width * 0.2
                verticalAlignment: Text.AlignVCenter
            }

            Text {
                id: playTuneToggle
                text: playTuneOnSolve ? "On" : "Off"
                color: "white"
                font.pixelSize: 20
                anchors.right: parent.right
                anchors.rightMargin: parent.width * 0.2
                verticalAlignment: Text.AlignVCenter

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                        playTuneOnSolve = !playTuneOnSolve
                        console.log("Play tune on solve: " + playTuneOnSolve)
                    }
                }
            }
        }
    }

    // Sound effect for puzzle solved (example, you'd trigger this from game logic)
    SoundEffect {
        id: puzzleSolvedSound
        source: "qrc:/sounds/puzzle_solved" // Replace with your sound file
        volume: playTuneOnSolve ? 1.0 : 0.0 // Control volume based on setting
    }

    BackButton {
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        anchors.margins: 40
        onClicked: {
            stackView.pop()
        }
    }
}
