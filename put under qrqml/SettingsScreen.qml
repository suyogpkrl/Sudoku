import QtQuick
import QtQuick.Controls
import QtQuick.Window
import QtMultimedia

Item {
    id: settingScreen
    width: parent.width
    height: parent.height
    visible: true
    anchors.centerIn: parent

    property int screenState: mainWindow.visibility
    property bool playTuneOnSolve: true // Default to true
    property bool backgroundSound: true // Default to true
    property var backgroundColors: ["#bb3f17" , "#3f6032"]
    property var backgroundColorsName: ["Rust","Deep Moss Green"]
    property int backgroundColorIndex: 0

    Component.onCompleted: {
        backgroundSound = mainWindow.backgroundSoundOn
    }

    Column {
        id: settingsColumn
        width: parent.width
        anchors.top: parent.top
        anchors.topMargin: parent.height * 0.05
        spacing: 20

        // Display Section
        Column {
            width: parent.width
            spacing: 10

            Text {
                text: "Display"
                color: mainWindow.textMainColour
                font.pixelSize: 24
                font.bold: true
                //font.family: quicksandBold.name
                anchors.left: parent.left
                anchors.leftMargin: parent.width * 0.05
            }

            // New: Background Color Setting
            Row {
                width: parent.width * 0.8
                anchors.horizontalCenter: parent.horizontalCenter
                height: childrenRect.height

                Text {
                    text: "Background Color:"
                    color: mainWindow.textMainColour
                    font.pixelSize: 20
                    //font.family: quicksandBold.name
                    anchors.left: parent.left
                    verticalAlignment: Text.AlignVCenter
                }

                Text {
                    id: backgroundColorValue
                    text: backgroundColorsName[backgroundColorIndex]
                    color: mainWindow.textMainColour
                    font.pixelSize: 20
                    //font.family: quicksandBold.name
                    anchors.right: parent.right
                    verticalAlignment: Text.AlignVCenter

                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            backgroundColorIndex = (backgroundColorIndex + 1) % backgroundColors.length

                            mainWindow.color = backgroundColors[backgroundColorIndex]
                        }
                    }
                }
            }
        }

        // Sound Section
        Column {
            width: parent.width
            spacing: 10

            Text {
                text: "Sound"
                color: mainWindow.textMainColour
                font.pixelSize: 24
                font.bold: true
                //font.family: quicksandBold.name
                anchors.left: parent.left
                anchors.leftMargin: parent.width * 0.05
            }

            // Play Tune on Solve Setting
            Row {
                width: parent.width * 0.8
                anchors.horizontalCenter: parent.horizontalCenter
                height: childrenRect.height

                Text {
                    text: "Play Tune on Solve:"
                    color: mainWindow.textMainColour
                    font.pixelSize: 20
                    //font.family: quicksandBold.name
                    anchors.left: parent.left
                    verticalAlignment: Text.AlignVCenter
                }

                Text {
                    id: playTuneToggle
                    text: playTuneOnSolve ? "On" : "Off"
                    color: mainWindow.textMainColour
                    font.pixelSize: 20
                    //font.family: quicksandBold.name
                    anchors.right: parent.right
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

            // New: Background Sound Setting
            Row {
                width: parent.width * 0.8
                anchors.horizontalCenter: parent.horizontalCenter
                height: childrenRect.height

                Text {
                    text: "Background Sound:"
                    color: mainWindow.textMainColour
                    font.pixelSize: 20
                    //font.family: quicksandBold.name
                    anchors.left: parent.left
                    verticalAlignment: Text.AlignVCenter
                }

                Text {
                    id: backgroundSoundToggle
                    text: backgroundSound ? "On" : "Off"
                    color: mainWindow.textMainColour
                    font.pixelSize: 20
                    //font.family: quicksandBold.name
                    anchors.right: parent.right
                    verticalAlignment: Text.AlignVCenter

                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            backgroundSound = !backgroundSound
                            mainWindow.backgroundSoundOn = backgroundSound
                            console.log("Background sound: " + backgroundSound)
                        }
                    }
                }
            }

            // New: Master Volume Setting (Slider)
            Row {
                width: parent.width * 0.8
                anchors.horizontalCenter: parent.horizontalCenter
                height: childrenRect.height

                Text {
                    text: "Master Volume:"
                    color: mainWindow.textMainColour
                    font.pixelSize: 20
                    //font.family: quicksandBold.name
                    anchors.left: parent.left
                    verticalAlignment: Text.AlignVCenter
                }

                Slider {
                    id: masterVolumeSlider
                    anchors.right: parent.right
                    width: parent.width * 0.5 // Adjust width as needed
                    from: 0.0
                    to: 1.0
                    stepSize: 0.1
                    value: 0.5 // Default volume
                    background: Rectangle {
                        implicitWidth: 200
                        implicitHeight: 4
                        radius: 2
                        color: mainWindow.textMainColour
                    }
                    handle: Rectangle {
                        x: masterVolumeSlider.leftPadding + masterVolumeSlider.visualPosition * (masterVolumeSlider.availableWidth - implicitWidth)
                        implicitWidth: 20
                        implicitHeight: 20
                        radius: 10
                        color: mainWindow.textMainColour
                    }
                    onValueChanged: {
                        console.log("Master Volume: " + value)
                        // Implement master volume control logic here
                    }
                }
            }
        }

        // Accessibility Section
        Column {
            width: parent.width
            spacing: 10

            Text {
                text: "Accessibility"
                color: mainWindow.textMainColour
                font.pixelSize: 24
                font.bold: true
                //font.family: quicksandBold.name
                anchors.left: parent.left
                anchors.leftMargin: parent.width * 0.05
            }

            // Reset Popup Setting
            Row {
                width: parent.width * 0.8
                anchors.horizontalCenter: parent.horizontalCenter
                height: childrenRect.height

                Text {
                    text: "Reset Popup:"
                    color: mainWindow.textMainColour
                    font.pixelSize: 20
                    //font.family: quicksandBold.name
                    anchors.left: parent.left
                    verticalAlignment: Text.AlignVCenter
                }

                Text {
                    id: resetPopupToggle
                    text: (mainWindow.resetPopDisplayState)?"Show":"Don't Show"
                    color: mainWindow.textMainColour
                    font.pixelSize: 20
                    //font.family: quicksandBold.name
                    anchors.right: parent.right
                    verticalAlignment: Text.AlignVCenter

                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            mainWindow.resetPopDisplayState = !mainWindow.resetPopDisplayState
                        }
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
