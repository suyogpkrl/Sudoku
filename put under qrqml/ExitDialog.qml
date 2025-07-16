import QtQuick
import QtQuick.Controls

Rectangle {
    id: exitDialog
    width: 400
    height: 200
    color: "transparent"
    radius: 10
    border.color: mainWindow.borderMainColour
    border.width: 2
    anchors.centerIn: overlayRectangle
    visible: false
    z:99

    property alias dialogTitle: dialogTitle.text

    Text {
        id: dialogTitle
        text: "Exit Sudoku?"
        color: mainWindow.textMainColour
        font {
            //family: quicksandBold.name
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
        color: mainWindow.textMainColour
        font {
            //family: quicksandRegular.name
            pixelSize: 18
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
            color: "transparent"
            radius: 5
            border.width: 1
            border.color: mainWindow.borderMainColour

            Text {
                text: "Yes"
                color: mainWindow.textMainColour
                anchors.centerIn: parent
                font {
                    //family: quicksandMedium.name
                    pixelSize: 15
                }
            }

            MouseArea {
                            id: yesMouseArea
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.BlankCursor
                            onPressed: yesButton.color = "#60228201"
                            onReleased: yesButton.color= "transparent"
                            onClicked: {
                                mainWindow.powerOn = false;
                                Qt.quit();
                            }
                        }
        }

        Rectangle {
            id: noButton
            width: 80
            height: 30
            color: "transparent"
            radius: 5
            border.width: 1
            border.color: mainWindow.borderMainColour

            Text {
                text: "No"
                color: mainWindow.textMainColour
                anchors.centerIn: parent
                font {
                    //family: quicksandMedium.name
                    pixelSize: 15
                }
            }

            MouseArea {
                            id: noMouseArea
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.BlankCursor
                            onPressed: noButton.color = "#60228201"
                            onReleased: noButton.color = "transparent"
                            onClicked: {
                                exitDialog.visible = false;
                                menuColumn.visible = true;
                            }
                        }
        }
    }

    function open() {
        exitDialog.visible = true
    }
}
