import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import QtQuick.Controls.Fusion
import QtQuick.Layouts 1.15

Rectangle{
    id:activitylog
    width: parent.width-200
    height: 450
    visible: true
    radius: 5
    color: "#00000000"
    border.color: "white"
    border.width: 1

    Column{
        id:activitylogcolumn
        width:parent.width
        height:headeractivitylog.height+bodyactivitylog.height

        Rectangle{
            id:headeractivitylog
            height: 50
            width: parent.width
            color: "#00000000"
        }
        Rectangle{
            id:bodyactivitylog
            height:400
            width: parent.width
            color: "#00000000"
        }
    }
}
