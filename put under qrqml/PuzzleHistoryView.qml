import QtQuick 2.15
import QtQuick.Controls 2.15

Item {
    id: puzzleHistoryView
    width: parent.width
    height: parent.height

    property string date: ""
    property int time: 0
    property int difficulty: 0
    property string gridString: ""
    property var grid: []

    Component.onCompleted: {
        if (gridString) {
            grid = JSON.parse(gridString);
        }
    }

    Rectangle{
        id:historyTitle
        height: 50
        color: "transparent"
        anchors.top: borderControl.top
        anchors.right:backButtonOption.right
        anchors.left:borderControl.right
        anchors.leftMargin: 20
        Text{
            text: "History"
            anchors{
                verticalCenter: parent.verticalCenter
                horizontalCenter: parent.horizontalCenter
            }
            font{
                pixelSize: 24
                bold: true
            }
            color: mainWindow.textMainColour
        }
    }

        Rectangle{
            id:borderControl
            width: Math.min(parent.width, parent.height) * 0.8
            height: width
            color:"transparent"
            border.width: 2
            border.color: mainWindow.borderMainColour
            anchors.left: parent.left
            anchors.leftMargin: 60
            anchors.verticalCenter: parent.verticalCenter

            Grid {
                id: sudokuGrid
                columns: 9
                rows: 9
                spacing: 0
                anchors.fill: parent

                Repeater {
                    model: puzzleHistoryView.grid
                    delegate: Rectangle {
                        width: sudokuGrid.width / 9
                        height: sudokuGrid.height / 9
                        color: "transparent"
                        border.width: 1
                        border.color: mainWindow.borderMainColour

                        Text {
                            text: modelData > 0 ? modelData : ""
                            anchors.centerIn: parent
                            color: mainWindow.textMainColour
                            font.pixelSize: 20
                        }
                    }
                }
            }
        }


    Column{
        spacing:10
        anchors.right:backButtonOption.right
        anchors.top:historyTitle.bottom
        anchors.topMargin: 10
        anchors.left:borderControl.right
        anchors.leftMargin: 20

        Rectangle{
            anchors.right:parent.right
            border.width: 2
            border.color: mainWindow.borderMainColour
            radius: 5
            height:50
            width:parent.width
            color: "transparent"
        Text {
            text: "Time: " + puzzleHistoryView.time + " seconds"
            color: mainWindow.textMainColour
            font.pixelSize: 20
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            anchors.rightMargin: 10
            anchors.leftMargin: 10
            wrapMode: Text.WordWrap
        }
        }
        Rectangle{
            anchors.right:parent.right
            border.width: 2
            border.color: mainWindow.borderMainColour
            radius: 5
            height:90
            width:parent.width
            color: "transparent"
        Text {
            text: "Date: " + puzzleHistoryView.date
            color: mainWindow.textMainColour
            font.pixelSize: 20
            width:parent.width-20
            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenter: parent.horizontalCenter
            wrapMode: Text.WordWrap
            lineHeight: 1
        }
        }

        Rectangle{
            anchors.right:parent.right
            border.width: 2
            border.color: mainWindow.borderMainColour
            radius: 5
            height:50
            width:parent.width
            color: "transparent"
        Text {
            text: "Difficulty: " + (puzzleHistoryView.difficulty === 1 ? "Easy" : (puzzleHistoryView.difficulty === 2 ? "Medium" : "Hard"))
            color: mainWindow.textMainColour
            font.pixelSize: 20
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            anchors.rightMargin: 10
            anchors.leftMargin: 10
            wrapMode: Text.WordWrap
        }
        }
    }

    BackButton {
        id:backButtonOption
        anchors.bottom: borderControl.bottom
        anchors.right: parent.right
        anchors.rightMargin: 60
        onClicked: {
            stackView.pop()
        }
    }
}
