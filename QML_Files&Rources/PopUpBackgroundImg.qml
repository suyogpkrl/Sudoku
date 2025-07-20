import QtQuick

Rectangle {
    id: popUpBackgroundImg
    anchors.fill: parent
    radius: 10
    border.color: mainWindow.borderMainColour
    border.width: 2
    color: "transparent"

    // Background image (optimized to use the existing monitor image)
    Image {
        id: popupBackground
        source: "qrc:/ImgResources/Screen/Monitor.png"
        height: monitorImage.height
        fillMode: Image.PreserveAspectFit

        // Adjust vertical position with an offset
        anchors {
            centerIn: parent
            verticalCenterOffset: +parent.height*0.2
        }

        z: -1 // Ensure it's behind the dialog content
        // This image could be cached or optimized further
    }
}
