import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import QtQuick.Controls.Fusion
import QtQuick.Layouts 1.15

ApplicationWindow {
    id: mainWindow
    title: qsTr("Sudoku") //Name of window
    visibility: Window.Maximized
    minimumWidth: 800
    minimumHeight: minimumWidth*(9/16)

    /*onWidthChanged: if (visibility === Window.Windowed) height = width * (9/16)
      onHeightChanged: if (visibility === Window.Windowed) width = height * (16/9)*/
    //to maintain aspect ratio

    // Uses fusion theme
    Component.onCompleted: {
        ApplicationWindow.style = Fusion
    }

    // Fade In Component for mainWindow
    Component {
        id: mfadeInComponent
        ParallelAnimation {
            id: parallelAnim2
            onStarted: {
                leftHalf.visible = true
                rightHalf.visible = true
            }

            NumberAnimation {
                target: leftHalf
                property: "opacity"
                from: 0
                to: 1
                duration: 700
            }
            NumberAnimation {
                target: rightHalf
                property: "opacity"
                from: 0
                to: 1
                duration: 700
            }
            onStopped: {
                parallelAnim2.destroy()
            }
        }
    }

    // Fade Out Component
    Component {
        id: mfadeOutComponent
        ParallelAnimation {
            id: parallelAnim1
            NumberAnimation {
                target: leftHalf
                property: "opacity"
                from: 1
                to: 0
                duration: 350
            }
            NumberAnimation {
                target: rightHalf
                property: "opacity"
                from: 1
                to: 0
                duration: 350
            }
            onStopped: {
                leftHalf.visible = false
                rightHalf.visible = false
                parallelAnim1.destroy()
            }
        }
    }

    // Fade In Component for playchoose
    Component {
        id: pcfadeInComponent
        ParallelAnimation {
            id: parallelAnim3
            onStarted: {
                playchoose.visible= true
            }

            NumberAnimation {
                target: playchoose
                property: "opacity"
                from: 0
                to: 1
                duration: 700
            }
            onStopped: {
                parallelAnim3.destroy()
            }
        }
    }

    // Fade In Component for playchoose
    Component {
        id: pcfadeOutComponent
        ParallelAnimation {
            id: parallelAnim4
            NumberAnimation {
                target: playchoose
                property: "opacity"
                from: 1
                to: 0
                duration: 350
            }
            onStopped: {
                playchoose.opacity = false
                parallelAnim4.destroy()
            }
        }
    }

    //loading fonts which are not available in QT creator
    FontLoader { id: quicksandBold; source: "qrc:/fonts/Quicksand-Bold.ttf" }
    FontLoader { id: quicksandMedium; source: "qrc:/fonts/Quicksand-Medium.ttf" }
    FontLoader { id: quicksandRegular; source: "qrc:/fonts/Quicksand-Regular.ttf" }

    Item{
        id: aspectratio
        anchors.centerIn: parent
        width: if(aspectratio.height>mainWindow.height)
               {
                   parent.height*(16/9)
               }
               else
               {
                   parent.width
               }

        height: width*(9/16)
        // Background image
        Image {
            id: background
            anchors.fill: parent
            source: "qrc:/backgroundmain.jpg"
            fillMode: Image.PreserveAspectCrop
            opacity: 0.85
        }

        // Declare the playScreen as a property
            property var playScreen: null

        //The main menu is divided into two halfs , one for the options and another for the credit and tictactoe

        // Left Half - Menu Options
        Item {
            visible :true
            id: leftHalf
            width: parent.width / 2
            height: parent.height


            // Game Logo
            Image {
                id: logo
                source: "qrc:/logo.png"
                anchors {
                    horizontalCenter: parent.horizontalCenter
                    top: parent.top
                    topMargin: parent.height * 0.1
                }
                width: 100
                height: width
                fillMode: Image.PreserveAspectFit  //to fit the image in the given ratio maintaining its original aspect ratio
            }

            // Menu Options (Text Only)
            Column {
                id: menuColumn
                anchors.centerIn: parent //parent is Item here
                spacing: 30
                width: parent.width * 0.5

                Text {
                    id: playOption
                    text: "PLAY"
                    color: "white"
                    font {
                        family: quicksandMedium.name
                        pixelSize: 32
                    }
                    anchors.horizontalCenter: parent.horizontalCenter //centers the text horizonatlly to the parent(column of id menucolumn) in this case

                    SequentialAnimation on scale {//sequential allows multiple animation at same time
                        id: playAnim
                        running: false
                        loops: 1
                        //animation which effects numerical value
                        NumberAnimation { to: 1.1; duration: 100 } //grows the text to 1.1 times its original size in 1 second
                        NumberAnimation { to: 1.0; duration: 100 }//vice versa
                    }

                    MouseArea { //checks for mouse movement or actions in the parent (text of id playOption) in this case
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor //changes cursor to hand clicking when mouse is over the text region
                        onEntered: { //when the text region is entered (hovered)
                            playOption.font.bold = true
                            playAnim.start()
                        }
                        onExited: playOption.font.bold = false //when the text region is exited (cursor moved away)
                        onClicked:{
                            var mfadeOut = mfadeOutComponent.createObject(mainWindow)
                            var pcfadeIn = pcfadeInComponent.createObject(playchoose)
                            mfadeOut.start()
                            pcfadeIn.start()
                             }

                    }
                }

                //same as playOption
                Text {
                    id: solverOption
                    text: "SOLVER"
                    color: "white"
                    font {
                        family: quicksandMedium.name
                        pixelSize: 32
                    }
                    anchors.horizontalCenter: parent.horizontalCenter

                    SequentialAnimation on scale {
                        id: solverAnim
                        running: false
                        loops: 1
                        NumberAnimation { to: 1.1; duration: 100 }
                        NumberAnimation { to: 1.0; duration: 100 }
                    }

                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onEntered: {
                            solverOption.font.bold = true
                            solverAnim.start()
                        }
                        onExited: solverOption.font.bold = false
                        onClicked: console.log("Solver clicked")
                    }
                }

                //same as playOption
                Text {
                    id: historyOption
                    text: "HISTORY"
                    color: "white"
                    font {
                        family: quicksandMedium.name
                        pixelSize: 32
                    }
                    anchors.horizontalCenter: parent.horizontalCenter

                    SequentialAnimation on scale {
                        id: historyAnim
                        running: false
                        loops: 1
                        NumberAnimation { to: 1.1; duration: 100 }
                        NumberAnimation { to: 1.0; duration: 100 }
                    }

                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onEntered: {
                            historyOption.font.bold = true
                            historyAnim.start()
                        }
                        onExited: historyOption.font.bold = false
                        onClicked: console.log("History clicked")
                    }
                }

                //same as playOption
                Text {
                    id: exitOption
                    text: "EXIT"
                    color: "white"
                    font {
                        family: quicksandMedium.name
                        pixelSize: 32
                    }
                    anchors.horizontalCenter: parent.horizontalCenter

                    SequentialAnimation on scale {
                        id: exitAnim
                        running: false
                        loops: 1
                        NumberAnimation { to: 1.1; duration: 100 }
                        NumberAnimation { to: 1.0; duration: 100 }
                    }

                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onEntered: {
                            exitOption.font.bold = true
                            exitAnim.start()
                        }
                        onExited: exitOption.font.bold = false
                        onClicked: exitDialog.open()//When clicked it goes to the exitdialog rectangle which is initialized below (a pop-up)
                    }
                }
            }
        }

        // Right Half - Tic Tac Toe and Credits
        Item {
            visible : true
            id:rightHalf
            width: parent.width / 2
            height: parent.height
            anchors.right: parent.right
            //enter here tictactoe

            // Credits
            Rectangle {
                id: creditsBox
                width: parent.width - 100
                height: 60
                color: "#20000000"
                radius: 5
                anchors {
                    horizontalCenter: parent.horizontalCenter
                    bottom: parent.bottom
                    bottomMargin: 50
                }
                clip: true

                Text {
                    id: staticCreditsText
                    text: "CREDITS: "
                    color: "white"
                    font {
                        family: quicksandRegular.name
                        pixelSize: 18
                    }
                    anchors {
                        left: parent.left
                        verticalCenter: parent.verticalCenter
                        leftMargin: 10
                    }
                }

                //Animation (scrolling)

                Rectangle {
                    id: scrollingContainer
                    color: "#00000000"
                    width: parent.width - staticCreditsText.width - 20
                    height: parent.height
                    anchors {
                        left: staticCreditsText.right
                        verticalCenter: parent.verticalCenter
                    }
                    clip: true

                    Text {
                        id: scrollingCredits
                        text: "Sanskar Dhital • Sujay Ratna Sthapit • Subhash Sinjali • Suyog Pokhrel • Surasa Silpakar • " +
                              "Sanskar Dhital • Sujay Ratna Sthapit • Subhash Sinjali • Suyog Pokhrel • Surasa Silpakar • "
                        color: "white"
                        font {
                            family: quicksandRegular.name
                            pixelSize: 18 //same as font_size
                        }
                        y: (parent.height - height) / 2

                        // Start fully visible on the left (sets the corner to the start of the rectangle / text )
                        x: 0

                        // Define scroll duration as property
                        property int scrollDuration: 10000 // 10 seconds for full scroll


                        }
                        // Timer for initial delay
                        Timer {
                            id: initialDelay
                            interval: 2000 // 2 second initial delay
                            running: true
                            onTriggered: scrollAnim.start() //after two seconds the NumberAnimtion starts
                        }

                        // Main scrolling animation
                        NumberAnimation {
                            id: scrollAnim //just making easy to identify the number animation
                            target: scrollingCredits //the animation will effect this id
                            property: "x" //the animation will change the horizontal value
                            from: 0 //the x value will start from 0
                            to: -scrollingCredits.width/2
                            duration: scrollingCredits.scrollDuration // Use the defined property
                            loops: Animation.Infinite //will run endlessly
                            running: false //need to set it true somewhere else //initially the animation is false
                            easing.type: Easing.Linear //animation speed will be constant
                        }

                    }
                }
             }



        // Custom Exit Dialog
        Rectangle {
            id: exitDialog
            width: 400
            height: 200
            color: "#333"
            radius: 12
            border.color: "#555"
            anchors.centerIn: parent
            visible: false

            Text {
                id: dialogTitle
                text: "Exit Sudoku?"
                color: "white"
                font {
                    family: quicksandBold.name
                    pixelSize: 20
                }
                anchors { //anchors just means position , margins , padding ( idk qml has this or not)( why havent i tried doing it)
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
                spacing: 20 //spacing between two childern of the row parent

                // Yes Button
                Rectangle {
                    id: yesButton
                    width: 80
                    height: 30
                    color: yesMouseArea.containsPress ? "#60000000" :  //pressing
                          (yesMouseArea.containsMouse ? "#50000000" : "transparent") //hovering
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
                        onClicked: Qt.quit() //quits the QT program , hence closes the program
                    }
                }

                // No Button
                Rectangle {
                    id: noButton
                    width: 80
                    height: 30
                    color: noMouseArea.containsPress ? "#60000000" :
                          (noMouseArea.containsMouse ? "#50000000" : "transparent")
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
                        onClicked: exitDialog.visible = false //makes the popup invisible
                    }
                }
            }

            function open() {
                exitDialog.visible = true//when exitDialong.open() is ran , it makes the pop up visible
            }
        }

        //the online or offline mode
        Item {
            id:playchoose
            anchors.fill: parent
            opacity: 0
            visible: false

            Row{
                id:playchooserow
                height: childrenRect.height
                width: childrenRect.width
                spacing: parent.width/7
                visible: true
                anchors.centerIn: parent

                Rectangle{
                    height: playchoose.height/1.5 //can use parent instead of playchoose row
                    width: playchoose.width/3.5
                    radius: 12
                }
                Rectangle{
                    height: playchoose.height/1.5
                    width: playchoose.width/3.5
                    radius: 12
                }
            }

            Rectangle {
                id: playchooseback
                width: 100
                height: 40
                anchors{
                    bottom: parent.bottom
                    margins : 40
                    right: parent.right
                }
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

                MouseArea{
                    id: playchoosebackmousearea
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked:{
                        var mfadeIn = mfadeInComponent.createObject(mainWindow)
                        var pcfadeOut = pcfadeOutComponent.createObject(playchoose)
                        pcfadeOut.start()
                        mfadeIn.start()
                    }
                }
            }
        }
    }
}
