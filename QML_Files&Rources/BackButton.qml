/**
 * BackButton.qml
 * 
 * A reusable back button component that can be used throughout the application
 * to provide consistent navigation back to previous screens.
 */

import QtQuick
import QtQuick.Controls

Rectangle {
    id: theBackButton
    width: 100
    height: 40
    color: "transparent"
    radius: 5
    border.width: 2
    border.color: mainWindow.borderMainColour

    // Signal emitted when the button is clicked
    signal clicked

    // Button text
    Text {
        text: "Back"
        color: mainWindow.textMainColour
        anchors.centerIn: parent
        font.pixelSize: 15
        // Using direct font.pixelSize is more efficient than creating a font object
    }

    // Mouse area for handling interactions
    MouseArea {
        id: backMouseArea
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.BlankCursor
        
        // Visual feedback on press/release
        onPressed: theBackButton.color = "#60228201"
        onReleased: theBackButton.color = "transparent"
        
        // Emit the clicked signal when clicked
        onClicked: theBackButton.clicked()
    }
}