/**
 * ExitDialog.qml
 *
 * A dialog component that confirms if the user wants to exit the application.
 * Provides Yes/No options and handles the exit process.
 */

// Disable import warnings for this file pragma Prefer: NoWarnings

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

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
    clip: true
    z: 99

    // Allow customization of the dialog title
    property alias dialogTitle: dialogTitle.text

    // Background image (optimized to use the existing monitor image)
    Image {
        id: popupBackground
        source: "qrc:/ImgResources/Screen/Monitor.png"
        height: monitorImage.height
        fillMode: Image.PreserveAspectFit

        // Adjust vertical position with an offset
        anchors {
            horizontalCenter: parent.horizontalCenter
            verticalCenter: parent.verticalCenter
            verticalCenterOffset: +parent.height * 0.2 // Adjust this value as needed
        }

        z: -1 // Ensure it's behind the dialog content
        // This image could be cached or optimized further
    }

    // Dialog title
    Text {
        id: dialogTitle
        text: "Exit Sudoku?"
        color: mainWindow.textMainColour
        font.pixelSize: 20
        anchors {
            top: parent.top
            horizontalCenter: parent.horizontalCenter
            topMargin: 15
        }
    }

    // Dialog message
    Text {
        text: "Are you sure you want to exit?"
        color: mainWindow.textMainColour
        font.pixelSize: 18
        anchors.centerIn: parent
    }

    // Button row
    Row {
        anchors {
            bottom: parent.bottom
            horizontalCenter: parent.horizontalCenter
            bottomMargin: 15
        }
        spacing: 20

        // Yes button
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
                font.pixelSize: 15
            }

            MouseArea {
                id: yesMouseArea
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.BlankCursor
                onPressed: yesButton.color = "#60228201"
                onReleased: yesButton.color = "transparent"
                onClicked: {
                    mainWindow.powerOn = false;
                    Qt.quit();
                }
            }
        }

        // No button
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
                font.pixelSize: 15
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

    /**
     * Opens the exit dialog
     */
    function open() {
        exitDialog.visible = true;
    }
}
