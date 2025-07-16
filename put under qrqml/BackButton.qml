import QtQuick
import QtQuick.Controls

Rectangle {
    id:theBackButton
    width: 100
    height: 40
    color: "transparent"
    radius: 5
    border.width: 2
    border.color: mainWindow.borderMainColour

    signal clicked

    Text {
        text: "Back"
        color: mainWindow.textMainColour
        anchors.centerIn: parent
        font {
            //family: quicksandMedium.name
            pixelSize: 15
        }
    }

    MouseArea {
        id: backMouseArea
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.BlankCursor
        onPressed: theBackButton.color = "#60228201"
        onReleased: theBackButton.color ="transparent"
        onClicked: theBackButton.clicked()
    }
}
