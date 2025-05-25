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
    minimumHeight: 600

    // Uses fusion theme
    Component.onCompleted: {
        ApplicationWindow.style = Fusion
    }

    //loading fonts which are not available in QT creator
    FontLoader { id: quicksandBold; source: "qrc:/fonts/Quicksand-Bold.ttf" }
    FontLoader { id: quicksandMedium; source: "qrc:/fonts/Quicksand-Medium.ttf" }
    FontLoader { id: quicksandRegular; source: "qrc:/fonts/Quicksand-Regular.ttf" }

    // Background image
    Image {
        id: background
        anchors.fill: parent
        source: "qrc:/backgroundmain.jpg"
        fillMode: Image.PreserveAspectCrop
        opacity: 0.85
    }

    //The main menu is divided into two halfs , one for the options and another for the credit and tictactoe

    // Left Half - Menu Options
    Item {
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
                    onClicked: console.log("Play clicked") //for Future
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
        width: parent.width / 2
        height: parent.height
        anchors.right: parent.right

        // Tic Tac Toe Game
        Rectangle {
            id: ticTacToeBoard
            width: 300
            height: 300
            color: "#20000000"//#opacity R G B
            border.color: "white"
            border.width: 4
            radius: 5 //for curved corners
            anchors {
                horizontalCenter: parent.horizontalCenter
                top: parent.top
                topMargin: 150
            }

            // Grid Lines or kind of a table
            Row {
                spacing: 100
                anchors.centerIn: parent
                Repeater {
                    model: 2
                    Rectangle {
                        width: 4
                        height: 300
                        color: "white"
                    }
                }
            }
            Column {
                spacing: 100
                anchors.centerIn: parent
                Repeater {
                    model: 2
                    Rectangle {
                        width: 300
                        height: 4
                        color: "white"
                    }
                }
            }

            // Tic Tac Toe Grid
            Grid {
                id: ticTacToeGrid
                anchors.fill: parent
                columns: 3
                rows: 3
                property int currentPlayer: 0 // 0 for X, 1 for O , way of initializing variable in qml

                Repeater {
                    model: 9
                    Rectangle {
                        id: cell
                        width: 100
                        height: 100
                        color: "transparent"
                        property string mark: ""

                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                if (cell.mark === "") {
                                    cell.mark = ticTacToeGrid.currentPlayer === 0 ? "X" : "O"
                                    ticTacToeGrid.currentPlayer = 1 - ticTacToeGrid.currentPlayer
                                }
                            }
                        }

                        Text {
                            text: cell.mark
                            color: "white"
                            font {
                                family: quicksandBold.name
                                pixelSize: 60
                                weight: Font.Bold
                            }
                            anchors.centerIn: parent
                        }
                    }
                }
            }

            // Custom Reset Button
            Rectangle {
                id: resetButton
                width: 100
                height: 40
                color: resetMouseArea.containsPress ? "#60000000" :
                      (resetMouseArea.containsMouse ? "#50000000" : "#40000000")
                radius: 5
                border.width: 2
                border.color: "white"
                anchors {
                    bottom: parent.bottom
                    horizontalCenter: parent.horizontalCenter
                    bottomMargin: -50
                }

                Text {
                    text: "Reset"
                    color: "white"
                    anchors.centerIn: parent
                    font {
                        family: quicksandMedium.name
                        pixelSize: 16
                    }
                }

                MouseArea {
                    id: resetMouseArea
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                        for (var i = 0; i < ticTacToeGrid.children.length; i++) {
                            var cell = ticTacToeGrid.children[i]
                            if (cell && cell.mark !== undefined) {
                                cell.mark = ""
                            }
                        }
                        ticTacToeGrid.currentPlayer = 0
                    }
                }
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
                    text: "A-Little-Mouse • A-Little-Mouse • A-Little-Mouse • A-Little-Mouse • A-Little-Mouse • " +
                          "A-Little-Mouse • A-Little-Mouse • A-Little-Mouse • A-Little-Mouse • A-Little-Mouse • "
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
}
