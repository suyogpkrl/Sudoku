/**
 * SettingsScreen.qml
 *
 * A screen that allows users to configure application settings.
 * Includes display, sound, and accessibility options.
 */

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

    // Settings properties
    property int screenState: mainWindow.visibility
    property bool playTuneOnSolve: true
    property bool backgroundSound: true
    property var backgroundColors: ["#bb3f17", "#3f6032"]
    property var backgroundColorsName: ["Rust", "Deep Moss Green"]
    property int backgroundColorIndex: 0

    // Initialize settings from main window
    Component.onCompleted: {
        backgroundSound = mainWindow.backgroundSoundOn
    }

    // Settings container
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

            // Section header
            Text {
                text: "Display"
                color: mainWindow.textMainColour
                font {
                    pixelSize: 24
                    bold: true
                }
                anchors.left: parent.left
                anchors.leftMargin: parent.width * 0.05
            }

            // Background Color Setting
            Row {
                width: parent.width * 0.8
                anchors.horizontalCenter: parent.horizontalCenter
                height: childrenRect.height

                Text {
                    text: "Background Color:"
                    color: mainWindow.textMainColour
                    font.pixelSize: 20
                    anchors.left: parent.left
                    verticalAlignment: Text.AlignVCenter
                }

                Text {
                    id: backgroundColorValue
                    text: backgroundColorsName[backgroundColorIndex]
                    color: mainWindow.textMainColour
                    font.pixelSize: 20
                    anchors.right: parent.right
                    verticalAlignment: Text.AlignVCenter

                    // Toggle background color on click
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

            // Section header
            Text {
                text: "Sound"
                color: mainWindow.textMainColour
                font {
                    pixelSize: 24
                    bold: true
                }
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
                    anchors.left: parent.left
                    verticalAlignment: Text.AlignVCenter
                }

                Text {
                    id: playTuneToggle
                    text: playTuneOnSolve ? "On" : "Off"
                    color: mainWindow.textMainColour
                    font.pixelSize: 20
                    anchors.right: parent.right
                    verticalAlignment: Text.AlignVCenter

                    // Toggle play tune setting on click
                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            playTuneOnSolve = !playTuneOnSolve
                        }
                    }
                }
            }

            // Background Sound Setting
            Row {
                width: parent.width * 0.8
                anchors.horizontalCenter: parent.horizontalCenter
                height: childrenRect.height

                Text {
                    text: "Background Sound:"
                    color: mainWindow.textMainColour
                    font.pixelSize: 20
                    anchors.left: parent.left
                    verticalAlignment: Text.AlignVCenter
                }

                Text {
                    id: backgroundSoundToggle
                    text: backgroundSound ? "On" : "Off"
                    color: mainWindow.textMainColour
                    font.pixelSize: 20
                    anchors.right: parent.right
                    verticalAlignment: Text.AlignVCenter

                    // Toggle background sound on click
                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            backgroundSound = !backgroundSound
                            mainWindow.backgroundSoundOn = backgroundSound
                        }
                    }
                }
            }

            // Master Volume Setting
            Row {
                width: parent.width * 0.8
                anchors.horizontalCenter: parent.horizontalCenter
                height: childrenRect.height

                Text {
                    text: "Master Volume:"
                    color: mainWindow.textMainColour
                    font.pixelSize: 20
                    anchors.left: parent.left
                    verticalAlignment: Text.AlignVCenter
                }

                // Volume slider with custom styling
                Slider {
                    id: masterVolumeSlider
                    anchors.right: parent.right
                    width: parent.width * 0.5
                    from: 0.0
                    to: 1.0
                    stepSize: 0.1
                    value: 0.5 // Default volume

                    // Custom slider track
                    background: Rectangle {
                        implicitWidth: 200
                        implicitHeight: 4
                        radius: 2
                        color: mainWindow.textMainColour

                        // Show filled portion of the slider
                        Rectangle {
                            width: masterVolumeSlider.visualPosition * parent.width
                            height: parent.height
                            color: mainWindow.textMainColour
                            radius: 2
                        }
                    }

                    // Custom slider handle
                    handle: Rectangle {

                        property int Slidercords : handleball.x
                        onSlidercordsChanged: {
                            adjustVolume: slidercords;

                        }


                        x: masterVolumeSlider.leftPadding + masterVolumeSlider.visualPosition *
                           (masterVolumeSlider.availableWidth - width)
                        y: masterVolumeSlider.topPadding + masterVolumeSlider.availableHeight / 2 - height / 2



                        width: 20
                        height: 20
                        radius: 10
                        color: mainWindow.textMainColour
                    }
                }
            }
        }

        // Accessibility Section
        Column {
            width: parent.width
            spacing: 10

            // Section header
            Text {
                text: "Accessibility"
                color: mainWindow.textMainColour
                font {
                    pixelSize: 24
                    bold: true
                }
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
                    anchors.left: parent.left
                    verticalAlignment: Text.AlignVCenter
                }

                Text {
                    id: resetPopupToggle
                    text: (mainWindow.resetPopDisplayState) ? "Show" : "Don't Show"
                    color: mainWindow.textMainColour
                    font.pixelSize: 20
                    anchors.right: parent.right
                    verticalAlignment: Text.AlignVCenter

                    // Toggle reset popup setting on click
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

    // Sound effect for puzzle solved
    SoundEffect {
        id: puzzleSolvedSound
        source: "qrc:/AudioResources/SoundEffects/winningSoundEffect.wav"
        volume: playTuneOnSolve ? masterVolumeSlider.value : 0.0
    }

    // Back button
    BackButton {
        anchors {
            bottom: parent.bottom
            right: parent.right
            margins: 40
        }
        onClicked: {
            stackView.pop()
        }
    }
}
