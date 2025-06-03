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

    // Uses fusion theme
    Component.onCompleted: { //component.onCompleted means the component which is ApplicationWindow with id: mainWindow has fully loaded
        ApplicationWindow.style = Fusion //a inbuilt QTstyle
        //console.log(mainWindow.height) used to get total height of729
    }//does the same thing as style=fusion


    // Fade In Component for mainWindow
    Component {
        id: mfadeInComponent
        ParallelAnimation { //enables animation to be run in parallel
            id: parallelAnim2
            onStarted: {
                leftHalf.visible = true //to show or not to show the component
                rightHalf.visible = true
                leftHalf.enabled = false //the component will be visible but uninteractable
                rightHalf.enabled = false
            }

            NumberAnimation { //animation that changes numerical type values
                target: leftHalf
                property: "opacity" // the number animation will change the opacity of component with id: leftHalf
                from: 0
                to: 1
                duration: 700 //time
            }
            NumberAnimation {
                target: rightHalf
                property: "opacity"
                from: 0
                to: 1
                duration: 700
            }
            onStopped: {
                leftHalf.enabled = true
                rightHalf.enabled = true
                parallelAnim2.destroy()// Once completed gets destroyed // only to free memory , doesnt change its functions
            }
        }
    }

    // Fade Out Component for mainWindow
    Component {
        id: mfadeOutComponent
        ParallelAnimation {
            id: parallelAnim1
            onStarted: {
                leftHalf.enabled = false
                rightHalf.enabled = false
            }

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
                duration: 300
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
                playchoose.enabled = false
            }

            NumberAnimation {
                target: playchoose
                property: "opacity"
                from: 0
                to: 1
                duration: 700
            }
            onStopped: {
                playchoose.enabled = true
                parallelAnim3.destroy()
            }
        }
    }

    // Fade Out Component for playchoose
    Component {
        id: pcfadeOutComponent
        ParallelAnimation {
            id: parallelAnim4
            onStarted: {
                playchoose.enabled = false
            }

            NumberAnimation {
                target: playchoose
                property: "opacity"
                from: 1
                to: 0
                duration: 300
            }
            onStopped: {
                playchoose.visible = false
                parallelAnim4.destroy()
            }
        }
    }

    //fade In Component for singleplayerScreen
    Component {
        id: spsfadeInComponent
        ParallelAnimation {
            id: parallelAnim5
            onStarted: {
                singleplayerScreen.visible= true
                singleplayerScreen.enabled = false
            }

            NumberAnimation {
                target: singleplayerScreen
                property: "opacity"
                from: 0
                to: 1
                duration: 700
            }

            onStopped: {
                singleplayerScreen.enabled = true
                parallelAnim5.destroy()
            }
        }
    }

    //fade Out Component for singleplayerScreen
    Component {
        id: spsfadeOutComponent
        ParallelAnimation {
            id: parallelAnim6

            onStarted: {
                singleplayerScreen.enabled = false
            }

            NumberAnimation {
                target: singleplayerScreen
                property: "opacity"
                from: 1
                to: 0
                duration: 300
            }

            onStopped: {
                singleplayerScreen.visible= false
                parallelAnim6.destroy()
            }
        }
    }

    Component {
        id: sfadeInComponent
        ParallelAnimation{
            id: parallelAnim7
            onStarted:{
               settingScreen.visible = false
               settingScreen.enabled = false
            }

            NumberAnimation {
                target: settingScreen
                property: "opacity"
                from: 0
                to: 1
                duration: 700
            }

            onStopped: {
                settingScreen.enabled = true
                parallelAnim7.destroy()
            }
        }
    }

    //loading fonts which are not available in QT creator
    FontLoader { id: quicksandBold; source: "qrc:/fonts/Quicksand-Bold.ttf" }
    FontLoader { id: quicksandMedium; source: "qrc:/fonts/Quicksand-Medium.ttf" }
    FontLoader { id: quicksandRegular; source: "qrc:/fonts/Quicksand-Regular.ttf" }

    Item{
        id: aspectratio
        //to maintain the 16:9 aspect ratio on windowed
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
            fillMode: Image.PreserveAspectCrop //preserves apsect ratio , fills the window and crops the unseen part
            opacity: 0.8
        }

        //The main menu is divided into two halfs , one for the options and another for the credit and tictactoe

        // Left Half - Menu Options
        Item {
            id:leftHalf
            visible :true
            width: parent.width / 2
            height: parent.height


            // Game Logo
            Image {
                id: logo
                source: "qrc:/logo.png" //game logo
                anchors {
                    horizontalCenter: parent.horizontalCenter //centers the element to the horizontal of the leftHalf Item
                    top: parent.top // sticks to top
                    topMargin: parent.height * 0.1 // margin from top , requires top for it to work
                }
                width: 100
                height: width
                fillMode: Image.PreserveAspectCrop  //to fit the image in the given ratio maintaining its original aspect ratio
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

                    SequentialAnimation on scale {//sequential allows animation to run one after another
                        id: playAnim
                        running: false //if the animation has't started then it will wait until called with id.start() for example playAnim.start()
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
                            playAnim.start()//changes the running : false to true for id: playAnim
                        }
                        onExited: playOption.font.bold = false //when the text region is exited (cursor moved away)
                        onClicked:{
                            var mfadeOut = mfadeOutComponent.createObject(mainWindow)//component defined above
                            var pcfadeIn = pcfadeInComponent.createObject(playchoose)
                            mfadeOut.start() //starts the component defined on mfadeOut variable
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
                    id: settingOption
                    text: "SETTING"
                    color: "white"
                    font {
                        family: quicksandMedium.name
                        pixelSize: 32
                    }
                    anchors.horizontalCenter: parent.horizontalCenter

                    SequentialAnimation on scale {
                        id: settingAnim
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
                            settingOption.font.bold = true
                            settingAnim.start()
                        }
                        onExited: settingOption.font.bold = false
                        onClicked:{
                            rightHalf.visible = false
                            leftHalf.visible = false
                            settingScreen.visible =true
                        }
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
            anchors.topMargin:100
            anchors.right: parent.right
            //enter here tictactoe if you want ticTacToe

            Loader{ //dynamically loads and unloads the source , saves memory i guess
                id: activitylog
                width: parent.width-200 //loader will be the parent for the activitylog.qml so the height and width must be same
                height: 450
                source:"qrc:/customcomponents/activityLog.qml" //the loader loads this
                anchors{
                    horizontalCenter: parent.horizontalCenter
                    top: parent.top
                    topMargin: 100
                }
            }

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
                clip: true //doesn't show text when text is out of the bounds of the rectangle

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
                        text: "Be a little Mouse • Be a little Mouse • Be a little Mouse • Be a little Mouse • Be a little Mouse • " +
                              "Be a little Mouse • Be a little Mouse • Be a little Mouse • Be a little Mouse • Be a little Mouse • "
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
            z:100 //usually 0 , even though all components have z=0 by default the component which is defined later is shown above

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
            enabled: false

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

                    MouseArea{
                        id:singleplayerbutton
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        hoverEnabled: true
                        onClicked: {
                            var pcfadeOut = pcfadeOutComponent.createObject(playchoose)
                            var spsfadeIn = spsfadeInComponent.createObject(singleplayerScreen)
                            pcfadeOut.start()
                            spsfadeIn.start()
                        }
                    }
                }
                Rectangle{
                    height: playchoose.height/1.5
                    width: playchoose.width/3.5
                    radius: 12
                    MouseArea{
                        id:multiplayerbutton
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        hoverEnabled: true
                        onClicked: {
                            var pcfadeOut = pcfadeOutComponent.createObject(playchoose)
                            pcfadeOut.start()
                        }
                    }
                }
            }

            Loader {
                id:playchooseBackLoader
                width: 100
                height: 40
                anchors{
                    bottom: parent.bottom
                    right: parent.right
                    margins: 40
                }
                source: "qrc:/customcomponents/backButton.qml"

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
                    z:1
                }
            }
        }
    }


    //The actual Game
    Item{
        id: singleplayerScreen
        anchors.fill: parent
        opacity: 0
        visible: false
        enabled: false

        Rectangle{
            id:playertools
            anchors{
                right: parent.right
                top: parent.top
                bottom: parent.bottom
                margins: 40
                bottomMargin: 100
            }
            border.color: "white"
            border.width: 2
            width: 340
            radius: 5
            color: "#30000000"
        }
        Loader {
            id:singleplayerScreenLoader
            width: 100
            height: 40
            anchors{
                bottom: parent.bottom
                right: parent.right
                margins: 40
            }
            source: "qrc:/customcomponents/backButton.qml"

            MouseArea{

                id: singleplayerScreenbackmousearea
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked:{
                    var pcfadeIn = pcfadeInComponent.createObject(playchoose)
                    var spsfadeOut = spsfadeOutComponent.createObject(singleplayerScreen)
                    pcfadeIn.start()
                    spsfadeOut.start()
                }
                z:1
            }
        }
    }

    
}
