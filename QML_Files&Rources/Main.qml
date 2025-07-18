/**
 * main.qml
 *
 * The main application window for the Sudoku game.
 * Provides the retro computer monitor interface and main menu.
 */

import QtQuick
import QtQuick.Window
import QtQuick.Controls
import QtQuick.Controls.Fusion
import QtMultimedia

ApplicationWindow {
    id: mainWindow
    visible: true
    minimumWidth: 1000
    minimumHeight: 1000 * 9/16
    title: "Sudoku"
    visibility: Window.FullScreen
    color: "#bb3f17"

    // Image properties
    property alias monitorImage: monitorImage
    property alias overlayRectangle: overlayRectangle

    // Settings properties
    property bool backgroundSoundOn: false
    property bool resetPopDisplayState: true

    // Startup properties
    property bool powerOn: false
    property bool longPressPowerOn: false

    // Program functionality properties
    property alias gameTimer: gameTimer
    property bool menuColumnVisible: menuColumn.visible

    // Theme properties
    property color textMainColour: "#228201"
    property color borderMainColour: "#228201"
    property bool showCursor: false

    // Initialize application style
    Component.onCompleted: ApplicationWindow.style = Fusion

    // Handle background sound changes
    onBackgroundSoundOnChanged: backgroundSoundOn ? playerMusic.play() : playerMusic.pause()

    // Handle menu visibility changes
    onMenuColumnVisibleChanged: menuColumnAnim.start()

    // Background music player
    MediaPlayer {
        id: playerMusic
        source: "qrc:/AudioResources/Music/GlassBeans-MahalEP.mp3"
        audioOutput: AudioOutput {}
        loops: MediaPlayer.Infinite
    }

    // Cursor area overlay
    Rectangle {
        id: overlayRectangle
        width: parent.width * 0.48
        height: parent.height * 0.57
        anchors {
            horizontalCenter: parent.horizontalCenter
            bottom: parent.bottom
            bottomMargin: parent.height * 0.251
        }
        color: "transparent"
        z: 1000

        // Title container
        Rectangle {
            anchors.centerIn: parent
            visible: true
            width: sudokuTitleText.width
            height: childrenRect.height
            clip: true
            color: "transparent"

            // Animated title
            Rectangle {
                id: sudokuTitle
                visible: true
                anchors.left: parent.left
                width: 0
                height: childrenRect.height
                clip: true
                color: "transparent"

                Text {
                    id: sudokuTitleText
                    text: "SUDOKU"
                    color: mainWindow.textMainColour
                    font { pixelSize: 80; bold: true }
                    anchors.left: parent.left
                }

                // Title animation
                SequentialAnimation on width {
                    id: sudokuTitleAnimation
                    running: false
                    loops: 1
                    NumberAnimation {
                        to: sudokuTitleText.width
                        duration: 1500
                        easing.type: Easing.linear
                    }
                    onStopped: {
                        menuColumn.visible = true
                        sudokuTitle.visible = false
                        showCursor = true
                    }
                }
            }
        }

        // Custom cursor image
        Image {
            id: customCursorImage
            source: "qrc:/ImgResources/Cursor/customCursor.png"
            visible: showCursor
            z: 100
            height: 28
            fillMode: Image.PreserveAspectFit

            // Cache the image for better performance
            cache: true
            asynchronous: true
        }

        // Mouse area for custom cursor
        MouseArea {
            anchors.fill: parent
            anchors.margins: 20
            hoverEnabled: true
            acceptedButtons: Qt.NoButton
            propagateComposedEvents: true
            cursorShape: mainWindow.powerOn ? Qt.BlankCursor : Qt.ArrowCursor

            onEntered: if(mainWindow.powerOn) customCursorImage.visible = true
            onExited: customCursorImage.visible = false

            onPositionChanged: {
                customCursorImage.x = mouse.x + 20
                customCursorImage.y = mouse.y + 20
            }
        }
    }
    //Disk control (music toggle)
    Image {
        id: diskImage
        source: "qrc:/ImgResources/Disk.png"
        width: 100
        height: 100
        anchors {
            right: parent.right
            bottom: parent.bottom
            rightMargin: parent.width * 0.05
            bottomMargin: parent.height * 0.05
        }

        // Cache the image for better performance
        cache: true
        asynchronous: true

        // Disk rotation animation
        RotationAnimation on rotation {
            id: diskRotationAnimation
            from: 0
            to: 360
            duration: 2000
            loops: Animation.Infinite
            running: mainWindow.backgroundSoundOn
        }

        // Disk click handler
        MouseArea {
            anchors.fill: parent
            hoverEnabled: true
            onEntered: diskImage.scale = 1.2
            onExited: diskImage.scale = 1.0
            onClicked: if(powerOn) mainWindow.backgroundSoundOn = !mainWindow.backgroundSoundOn
        }

        // Smooth scale animation
        Behavior on scale { PropertyAnimation { duration: 500 } }
    }

    // Main monitor image
    Image {
        id: monitorImage
        source: "qrc:/ImgResources/Screen/Monitor.png"
        height: parent.height * 0.85
        anchors.centerIn: parent
        fillMode: Image.PreserveAspectFit

        // Cache the image for better performance
        cache: true
        asynchronous: true

        // Power button
        Image {
            id: offButton
            source: mainWindow.powerOn ? "qrc:/ImgResources/Screen/ONButton.png" : "qrc:/ImgResources/Screen/OFFButton.png"
            height: parent.height * 0.05
            fillMode: Image.PreserveAspectFit
            anchors {
                right: parent.right
                bottom: parent.bottom
                rightMargin: parent.width * 0.0265
                bottomMargin: parent.height * 0.0325
            }

            // Cache the image for better performance
            cache: true
            asynchronous: true

            // Button press animation
            SequentialAnimation on scale {
                id: onButtonPressedAnim
                running: false
                loops: 1
                NumberAnimation { to: 0.94; duration: 100 }
            }

            // Button release animation
            SequentialAnimation on scale {
                id: onButtonReleasedAnim
                running: false
                loops: 1
                NumberAnimation { to: 1.0; duration: 100 }
            }
   // Power button click handler
            MouseArea {
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                anchors.fill: parent

                // Timer for long-press to quit
                Timer {
                    id: powerOffTimer
                    interval: 3000
                    repeat: false
                    onTriggered: Qt.quit()
                }

                onPressed: {
                    powerOffTimer.start()
                    onButtonPressedAnim.start()
                    computerOnPressedSoundEffect.play()
                }

                onReleased: {
                    powerOffTimer.stop()
                    onButtonReleasedAnim.start()
                    computerOnReleasedSoundEffect.play()
                }

                onClicked: {
                    if (!mainWindow.powerOn) {
                        mainWindow.powerOn = true
                        backgroundSoundOn = true
                        sudokuTitleAnimation.start()
                    } else if(menuColumn.visible) {
                        menuColumn.visible = false
                        exitDialog.open()
                    }
                }
            }
        }
    }

    // Timer display
    Image {
        id: timerIcon
        source: "qrc:/ImgResources/Time/Timer.png"
        height: parent.height * 0.2
        fillMode: Image.PreserveAspectFit
        anchors {
            left: parent.left
            leftMargin: parent.width * 0.025
        }
        y: parent.height - height * 0.2

        // Cache the image for better performance
        cache: true
        asynchronous: true

        // Timer indicator light
        Image {
            id: timerOnBlink
            source: "qrc:/ImgResources/Time/TimerBlink.png"
            height: timerIcon.height * 0.0919
            width: height * 1080/665
            anchors {
                right: parent.right
                rightMargin: parent.width * 0.0811
                top: parent.top
                topMargin: parent.height * 0.246
            }
            rotation: 0.4

            // Cache the image for better performance
            cache: true
            asynchronous: true
        }

        // Smooth movement animation
        Behavior on y { PropertyAnimation { duration: 500; easing.type: Easing.OutCubic } }        //Timer display
        Row {
            id: timerText
            anchors {
                top: parent.top
                topMargin: parent.height * 0.26
                right: parent.right
                rightMargin: parent.width * 0.319
            }
            spacing: parent.width * 0.14

            // Minutes display
            Text {
                id: minuteText
                text: "00"
                font.pixelSize: 40
                color: mainWindow.textMainColour
            }

            // Seconds display
            Text {
                id: secondText
                text: "00"
                color: mainWindow.textMainColour
                font.pixelSize: 40
            }

            // Blinking animation for active timer
            SequentialAnimation {
                id: switchAnimation
                running: false
                loops: Animation.Infinite
                ScriptAction { script: timerOnBlink.source = "qrc:/ImgResources/Time/TimerBlinkRed.png" }
                PauseAnimation { duration: 500 }
                ScriptAction { script: timerOnBlink.source = "qrc:/ImgResources/Time/TimerBlink.png" }
                PauseAnimation { duration: 500 }
            }

            // Game timer
            Timer {
                id: gameTimer
                interval: 1000
                running: false
                repeat: true
                property int seconds: 0

                onTriggered: {
                    switchAnimation.start()
                    seconds++
                    var minutes = Math.floor(seconds / 60)
                    var remainingSeconds = seconds % 60
                    minuteText.text = Qt.formatTime(new Date(0, 0, 0, 0, minutes, 0), "mm")
                    secondText.text = Qt.formatTime(new Date(0, 0, 0, 0, 0, remainingSeconds), "ss")
                }

                onRunningChanged: {
                    switchAnimation.stop()
                    timerOnBlink.source = "qrc:/ImgResources/Time/TimerBlink.png"
                }
            }
        }
    }
    // Main menu stack
    StackView {
        id: stackView
        anchors.fill: overlayRectangle
        initialItem: Item {
            id: mainMenuItem
            width: overlayRectangle.width
            height: overlayRectangle.height

            // Main menu column
            Column {
                id: menuColumn
                visible: false // Initially hidden

                // Menu animation
                SequentialAnimation on scale {
                    id: menuColumnAnim
                    running: false
                    loops: 1
                    NumberAnimation { property: "scale"; duration: 500; from: 0.85; to: 1.0 }
                }

                anchors.verticalCenter: parent.verticalCenter
                anchors.right: parent.right
                anchors.rightMargin: parent.width * 0.15
                spacing: 30

                // Play option
                Text {
                    id: playOption
                    text: "PLAY"
                    color: mainWindow.textMainColour
                    font.pixelSize: 32
                    anchors.right: parent.right

                    // Hover animation
                    SequentialAnimation on scale {
                        id: playAnim
                        running: false
                        loops: 1
                        NumberAnimation { to: 1.1; duration: 100 }
                        NumberAnimation { to: 1.0; duration: 100 }
                    }

                    MouseArea {
                        hoverEnabled: true
                        cursorShape: Qt.BlankCursor
                        anchors.fill: parent
                        onEntered: playAnim.start()
                        onClicked: {
                            stackView.push("PlayScreen.qml")
                        }
                    }
                }
       // Solver option
                Text {
                    id: solveOption
                    text: "SOLVER"
                    color: mainWindow.textMainColour
                    font.pixelSize: 32
                    anchors.right: parent.right

                    // Hover animation
                    SequentialAnimation on scale {
                        id: solveAnim
                        running: false
                        loops: 1
                        NumberAnimation { to: 1.1; duration: 100 }
                        NumberAnimation { to: 1.0; duration: 100 }
                    }

                    MouseArea {
                        hoverEnabled: true
                        cursorShape: Qt.BlankCursor
                        anchors.fill: parent
                        onEntered: solveAnim.start()
                        onClicked: {
                            stackView.push("Solver.qml")
                        }
                    }
                }

                // History option
                Text {
                    id: historyOption
                    text: "HISTORY"
                    color: mainWindow.textMainColour
                    font.pixelSize: 32
                    anchors.right: parent.right

                    // Hover animation
                    SequentialAnimation on scale {
                        id: historyAnim
                        running: false
                        loops: 1
                        NumberAnimation { to: 1.1; duration: 100 }
                        NumberAnimation { to: 1.0; duration: 100 }
                    }

                    MouseArea {
                        hoverEnabled: true
                        cursorShape: Qt.BlankCursor
                        anchors.fill: parent
                        onEntered: historyAnim.start()
                        onClicked: {
                            stackView.push("HistoryScreen.qml")
                        }
                    }
                }
             // Settings option
                Text {
                    id: settingOption
                    text: "SETTING"
                    color: mainWindow.textMainColour
                    font.pixelSize: 32
                    anchors.right: parent.right

                    // Hover animation
                    SequentialAnimation on scale {
                        id: settingAnim
                        running: false
                        loops: 1
                        NumberAnimation { to: 1.1; duration: 100 }
                        NumberAnimation { to: 1.0; duration: 100 }
                    }

                    MouseArea {
                        hoverEnabled: true
                        cursorShape: Qt.BlankCursor
                        anchors.fill: parent
                        onEntered: settingAnim.start()
                        onClicked: {
                            stackView.push("SettingsScreen.qml")
                        }
                    }
                }

                // Exit option
                Text {
                    id: exitOption
                    text: "EXIT"
                    color: mainWindow.textMainColour
                    font.pixelSize: 32
                    anchors.right: parent.right

                    // Hover animation
                    SequentialAnimation on scale {
                        id: exitAnim
                        running: false
                        loops: 1
                        NumberAnimation { to: 1.1; duration: 100 }
                        NumberAnimation { to: 1.0; duration: 100 }
                    }

                    MouseArea {
                        hoverEnabled: true
                        cursorShape: Qt.BlankCursor
                        anchors.fill: parent
                        onEntered: exitAnim.start()
                        onClicked: {
                            exitDialog.open()
                        }
                    }
                }
            }
        }
        //Stack view transitions
        pushEnter: Transition {
            NumberAnimation { property: "scale"; duration: 90; from: 0.85; to: 1.0 }
        }
        pushExit: Transition {
            NumberAnimation { property: "scale"; duration: 90; from: 1.0; to: 0.85 }
        }
        popEnter: Transition {
            NumberAnimation { property: "scale"; duration: 90; from: 0.85; to: 1.0 }
        }
        popExit: Transition {
            NumberAnimation { property: "scale"; duration: 90; from: 1.0; to: 0.85 }
        }
    }

    // Exit confirmation dialog
    ExitDialog {
        id: exitDialog
    }

    // Sound effects
    SoundEffect {
        id: computerOnPressedSoundEffect
        source: "qrc:/AudioResources/SoundEffects/computerOnPressedsoundeffect_EvJlnX9w.wav"
    }

    SoundEffect {
        id: computerOnReleasedSoundEffect
        source: "qrc:/AudioResources/SoundEffects/computerOnReleasedsoundeffect_KRd6hpUb.wav"
    }
}
