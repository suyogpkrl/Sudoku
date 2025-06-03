import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import QtQuick.Controls.Fusion
import QtQuick.Layouts 1.15


Rectangle {
        id:theBackButton
        color: yesMouseArea.containsPress ? "#60000000" :  //pressing
              (yesMouseArea.containsMouse ? "#50000000" : "#40000000") //hovering
        radius: 5
        border.width: 2
        border.color: "white"

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
            }
    }

