/*// Tic Tac Toe Game
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
        property int currentPlayer: 0 // 0 for X, 1 for O
        property bool gameActive: true // Add this to control game state

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
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                        if (cell.mark === "" && ticTacToeGrid.gameActive) {
                            cell.mark = ticTacToeGrid.currentPlayer === 0 ? "X" : "O"
                            ticTacToeGrid.checkWinner();
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

        function checkWinner() {
            // Check rows
            for (var i = 0; i < 3; i++) {
                if (children[i*3].mark !== "" &&
                    children[i*3].mark === children[i*3+1].mark &&
                    children[i*3+1].mark === children[i*3+2].mark) {
                    handleWin();
                    return;
                }
            }

            // Check columns
            for (i = 0; i < 3; i++) {
                if (children[i].mark !== "" &&
                    children[i].mark === children[i+3].mark &&
                    children[i+3].mark === children[i+6].mark) {
                    handleWin();
                    return;
                }
            }

            // Check diagonals
            if (children[0].mark !== "" &&
                children[0].mark === children[4].mark &&
                children[4].mark === children[8].mark) {
                handleWin();
                return;
            }

            if (children[2].mark !== "" &&
                children[2].mark === children[4].mark &&
                children[4].mark === children[6].mark) {
                handleWin();
                return;
            }

            // Switch player if no winner yet
            ticTacToeGrid.currentPlayer = 1 - ticTacToeGrid.currentPlayer;
        }

        function handleWin() {
            gameActive = false; // Disable further moves
            winTimer.start(); // Start the 4-second timer
        }

        Timer {
            id: winTimer
            interval: 3000 // 3 seconds delay
            onTriggered:{
                for (var i = 0; i < ticTacToeGrid.children.length; i++) {
                    var cell = ticTacToeGrid.children[i];
                    if (cell && cell.mark !== undefined) {
                        cell.mark = "";
                    }
                }
                ticTacToeGrid.currentPlayer = 0;
                ticTacToeGrid.gameActive = true; // Re-enable the game
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
                ticTacToeGrid.gameActive = true
            }
        }
    }
}*/
