import QtQuick
import QtQuick.Window
import QtQuick.Controls
import QtQuick.Controls.Fusion

ApplicationWindow {
    id: mainWindow
    visible: true
    width: 800
    height: 600
    title: "Sudoku"
    visibility: Window.Maximized

    Component.onCompleted: {
        ApplicationWindow.style = Fusion
    }

    FontLoader { id: quicksandBold; source: "qrc:/fonts/Quicksand-Bold.ttf" }
    FontLoader { id: quicksandMedium; source: "qrc:/fonts/Quicksand-Medium.ttf" }
    FontLoader { id: quicksandRegular; source: "qrc:/fonts/Quicksand-Regular.ttf" }

    Image {
        id: background
        anchors.fill: parent
        source: "qrc:/backgroundmain.jpg"
        fillMode: Image.PreserveAspectCrop
        opacity: 0.8
    }

    StackView {
        id: stackView
        anchors.fill: parent
        initialItem: Item {
            id: mainMenuItem
            width: parent.width
            height: parent.height

            Column {
                id: menuColumn
                anchors.centerIn: parent
                spacing: 30

                Text {
                    id: playOption
                    text: "PLAY"
                    color: "white"
                    font {
                        family: quicksandMedium.name
                        pixelSize: 32
                    }
                    anchors.horizontalCenter: parent.horizontalCenter

                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            stackView.push("PlayScreen.qml")
                        }
                    }
                }

                Text {
                    id: solveOption
                    text: "SOLVE"
                    color: "white"
                    font {
                        family: quicksandMedium.name
                        pixelSize: 32
                    }
                    anchors.horizontalCenter: parent.horizontalCenter

                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            stackView.push("Solver.qml")
                        }
                    }
                }

                Text {
                    id: settingOption
                    text: "SETTING"
                    color: "white"
                    font {
                        family: quicksandMedium.name
                        pixelSize: 32
                    }
                    anchors.horizontalCenter: parent.horizontalCenter

                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            stackView.push("SettingsScreen.qml")
                        }
                    }
                }

                Text {
                    id: exitOption
                    text: "EXIT"
                    color: "white"
                    font {
                        family: quicksandMedium.name
                        pixelSize: 32
                    }
                    anchors.horizontalCenter: parent.horizontalCenter

                    MouseArea {
                        anchors.fill: parent
                        onClicked: exitDialog.open()
                    }
                }
            }
        }
    }

    ExitDialog {
        id: exitDialog
    }
}