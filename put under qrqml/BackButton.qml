import QtQuick
import QtQuick.Controls

Rectangle {
    id:theBackButton
    width: 100
    height: 40
    color: backMouseArea.containsPress ? "#60000000" : (backMouseArea.containsMouse ? "#50000000" : "#40000000")
    radius: 5
    border.width: 2
    border.color: "white"

    signal clicked

    Text {
        text: "Back"
        color: "white"
        anchors.centerIn: parent
        font {
            family: quicksandMedium.name
            pixelSize: 15
        }
    }
    MouseArea {
        id: backMouseArea
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: theBackButton.clicked()
    }
}
