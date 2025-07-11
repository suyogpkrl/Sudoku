import QtQuick
import QtQuick.Controls

Rectangle {
    id: exitDialog
    width: 400
    height: 200
    color: "#333"
    radius: 12
    border.color: "#555"
    anchors.centerIn: parent
    visible: false
    z:100

    property alias dialogTitle: dialogTitle.text

    Text {
        id: dialogTitle
        text: "Exit Sudoku?"
        color: "white"
        font {
            family: quicksandBold.name
            pixelSize: 20
        }
        anchors {
            top: parent.top
            horizontalCenter: parent.horizontalCenter
            topMargin: 15
        }
    }

    Text {
        text: "Are you sure you want to exit?"
        color: "white"
        font {
            family: quicksandRegular.name
            pixelSize: 16
        }
        anchors.centerIn: parent
    }

    Row {
        anchors {
            bottom: parent.bottom
            horizontalCenter: parent.horizontalCenter
            bottomMargin: 15
        }
        spacing: 20

        Rectangle {
            id: yesButton
            width: 80
            height: 30
            color: yesMouseArea.containsPress ? "#60000000" : (yesMouseArea.containsMouse ? "#50000000" : "transparent")
            radius: 4
            border.width: 1
            border.color: "#555"

            Text {
                text: "Yes"
                color: "white"
                anchors.centerIn: parent
                font {
                    family: quicksandMedium.name
                    pixelSize: 14
                }
            }

            MouseArea {
                id: yesMouseArea
                anchors.fill: parent
                hoverEnabled: true
                onClicked: Qt.quit()
            }
        }

        Rectangle {
            id: noButton
            width: 80
            height: 30
            color: noMouseArea.containsPress ? "#60000000" : (noMouseArea.containsMouse ? "#50000000" : "transparent")
            radius: 4
            border.width: 1
            border.color: "#555"

            Text {
                text: "No"
                color: "white"
                anchors.centerIn: parent
                font {
                    family: quicksandMedium.name
                    pixelSize: 14
                }
            }

            MouseArea {
                id: noMouseArea
                anchors.fill: parent
                hoverEnabled: true
                onClicked: exitDialog.visible = false
            }
        }
    }

    function open() {
        exitDialog.visible = true
    }
}
