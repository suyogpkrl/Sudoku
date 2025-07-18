/**
 * PlayScreen.qml
 * 
 * The main game screen where users play Sudoku puzzles.
 * Handles puzzle generation, user input, validation, and game state.
 */

import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import com.sudoku.generator 1.0

Item {
    id: sudokuGameScreen
    visible: true
    width: parent.width
    height: parent.height

    // Game state properties
    property int selectedNumber: 0 // Currently selected number for input
    property bool gameStarted: false
    property int difficulty: 1 // 1: Easy, 2: Medium, 3: Hard
    property var sudokuPuzzle: [] // Stores the current puzzle
    property bool isPlayScreenLoaded: false
    property bool startButtonShowing: true

    // Initialize the screen
    Component.onCompleted: {
        // Position the timer icon
        timerIcon.y = mainWindow.height - timerIcon.height * 0.95
        isPlayScreenLoaded = true
        console.log("Play Screen Loaded")
    }

    // Handle keyboard input
    Keys.onPressed: function(event) {
        if (gameStarted && event.key >= Qt.Key_1 && event.key <= Qt.Key_9) {
            selectedNumber = event.key - Qt.Key_0;
            event.accepted = true;
        }
    }

    // Sudoku generator component
    SudokuGenerator {
        id: sudokuGenerator
        
        // Handle newly generated puzzles
        onSudokuGenerated: function(puzzle) {
            sudokuPuzzle = puzzle
            // Populate the grid with the generated puzzle
            for (var i = 0; i < 9; ++i) {
                for (var j = 0; j < 9; ++j) {
                    var cellIndex = i * 9 + j;
                    var cellItem = sudokuCellsRepeater.itemAt(cellIndex);
                    var cellInput = cellItem.children[0];
                    var value = sudokuPuzzle[i][j];
                    if (value !== 0) {
                        cellInput.text = value.toString();
                        cellItem.isGiven = true;
                    } else {
                        cellInput.text = "";
                        cellItem.isGiven = false;
                    }
                }
            }
        }
        
        // Handle puzzle check results
        onPuzzleChecked: function(status) {
            if (status === 1) { // Correct
                // Get current grid state
                var currentGrid = [];
                for (var i = 0; i < 9; i++) {
                    var row = [];
                    for (var j = 0; j < 9; j++) {
                        var cellIndex = i * 9 + j;
                        var cellItem = sudokuCellsRepeater.itemAt(cellIndex);
                        var cellInput = cellItem.children[0];
                        row.push(cellInput.text === "" ? 0 : parseInt(cellInput.text));
                    }
                    currentGrid.push(row);
                }
                
                // Save the completed puzzle
                sudokuGenerator.savePuzzle(currentGrid, mainWindow.gameTimer.seconds, difficulty);
                
                // Show success popup
                popup.popupTitle = "Congratulations!";
                popup.popupText = "You have solved the puzzle correctly.";
                popup.showCloseButton = true;
                popup.showResumeButton = false;
                popup.visible = true;
            } else if (status === 0) { // Incorrect
                popup.popupTitle = "Incorrect";
                popup.popupText = "The puzzle is not solved correctly.";
                popup.showCloseButton = true;
                popup.showResumeButton = true;
                popup.visible = true;
            } else { // Incomplete
                popup.popupTitle = "Incomplete";
                popup.popupText = "Please fill all the empty boxes.";
                popup.showCloseButton = true;
                popup.showResumeButton = true;
                popup.visible = true;
            }
        }
    }

    // Selected number display
    Rectangle {
        id: selectedNumberDisplay
        width: 140
        height: width
        radius: 5
        color: selectedNumber === 0 ? "transparent" : mainWindow.textMainColour
        border.color: mainWindow.borderMainColour
        border.width: 2
        anchors.right: parent.right
        anchors.top: borderControl.top
        anchors.rightMargin: 60

        Text {
            id: numberText
            text: sudokuGameScreen.selectedNumber === 0 ? "SELECT" : sudokuGameScreen.selectedNumber
            color: sudokuGameScreen.selectedNumber === 0 ? mainWindow.textMainColour : "#455663"
            font {
                pixelSize: sudokuGameScreen.selectedNumber === 0 ? 36 : 80
                bold: true
            }
            anchors.centerIn: parent
        }
    }

    // Difficulty selection column
    Column {
        id: difficultyOptions
        spacing: 10
        width: parent.width
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
        anchors.rightMargin: 60

        // Easy option
        Text {
            id: easyOption
            text: "Easy"
            color: mainWindow.textMainColour
            font.pixelSize: 24
            anchors.right: parent.right

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    if (!mainWindow.gameTimer.running) {
                        difficulty = 1
                        selectionArrow.y = sudokuGameScreen.height/2 - difficultyOptions.height/2 + 5
                    }
                }
            }
        }

        // Medium option
        Text {
            id: mediumOption
            text: "Medium"
            color: mainWindow.textMainColour
            font.pixelSize: 24
            anchors.right: parent.right

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    if (!mainWindow.gameTimer.running) {
                        difficulty = 2
                        selectionArrow.y = sudokuGameScreen.height/2 - mediumOption.height/2 + 5
                    }
                }
            }
        }

        // Hard option
        Text {
            id: hardOption
            text: "Hard"
            color: mainWindow.textMainColour
            font.pixelSize: 24
            anchors.right: parent.right

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    if (!mainWindow.gameTimer.running) {
                        difficulty = 3
                        selectionArrow.y = sudokuGameScreen.height/2 + difficultyOptions.height/2 - hardOption.height + 5
                    }
                }
            }
        }
    }

    // Selection arrow indicator
    Image {
        id: selectionArrow
        source: "qrc:/ImgResources/Screen/selectedOption.png"
        height: 24
        fillMode: Image.PreserveAspectFit
        anchors {
            left: difficultyOptions.right
            leftMargin: 5
        }
        y: sudokuGameScreen.height/2 - difficultyOptions.height/2 + 5 // Start at Easy position
    }

    // Sudoku grid container
    Rectangle {
        id: borderControl
        anchors.left: parent.left
        anchors.leftMargin: 40
        anchors.verticalCenter: parent.verticalCenter
        width: Math.min(parent.width, parent.height) * 0.8
        height: width
        color: "transparent"
        border.width: 2
        border.color: mainWindow.borderMainColour

        // 9x9 grid layout
        Grid {
            id: sudokuGrid
            columns: 9
            rows: 9
            spacing: 0
            anchors.fill: parent

            // Generate 81 cells (9x9)
            Repeater {
                id: sudokuCellsRepeater
                model: 81
                
                // Individual cell
                Rectangle {
                    width: sudokuGrid.width / 9
                    height: sudokuGrid.height / 9
                    color: "transparent"
                    border.width: 1
                    border.color: mainWindow.borderMainColour

                    property bool isGiven: false
                    property bool isCorrect: false

                    // Cell input field
                    TextInput {
                        id: cellInput
                        anchors.fill: parent
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        font.pixelSize: 20
                        color: isGiven ? "lightgray" : (isCorrect ? "blue" : "white")
                        readOnly: isGiven
                        validator: IntValidator { bottom: 1; top: 9; }

                        onAccepted: {
                            var num = parseInt(text, 10);
                            if (!isNaN(num)) {
                                var row = Math.floor(index / 9);
                                var col = index % 9;
                                isCorrect = sudokuGenerator.checkNumber(row, col, num);
                                if (!isCorrect) {
                                    text = "";
                                }
                            }
                            parent.focus = false;
                        }
                    }

                    // Cell click handler
                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            if (sudokuGameScreen.gameStarted && !isGiven && selectedNumber !== 0) {
                                cellInput.text = selectedNumber.toString();
                                var row = Math.floor(index / 9);
                                var col = index % 9;
                                isCorrect = sudokuGenerator.checkNumber(row, col, selectedNumber);
                                if (!isCorrect) {
                                    cellInput.color = "red"; // Indicate incorrect input
                                } else {
                                    cellInput.color = "blue"; // Indicate correct input
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    // Start button
    Rectangle {
        id: startButton
        width: 100
        height: 40
        color: "transparent"
        radius: 5
        border.width: 2
        border.color: mainWindow.borderMainColour
        visible: startButtonShowing
        anchors.bottom: borderControl.bottom
        anchors.bottomMargin: 60
        anchors.right: parent.right
        anchors.rightMargin: 60

        Text {
            text: "START"
            color: mainWindow.textMainColour
            anchors.centerIn: parent
            font.pixelSize: 15
        }
        
        MouseArea {
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.BlankCursor
            onPressed: startButton.color = "#60228201"
            onReleased: startButton.color = "transparent"
            onClicked: {
                sudokuGenerator.generateSudoku(difficulty);
                mainWindow.gameTimer.running = true;
                mainWindow.gameTimer.seconds = 0;
                sudokuGameScreen.gameStarted = true;
                startButtonShowing = false
                sudokuGameScreen.forceActiveFocus()
            }
        }
    }

    // Finish button
    Rectangle {
        id: finishButton
        width: 100
        height: 40
        color: "transparent"
        radius: 5
        border.width: 2
        border.color: mainWindow.borderMainColour
        visible: !startButton.visible
        anchors.bottom: borderControl.bottom
        anchors.right: parent.right
        anchors.rightMargin: 60

        Text {
            text: "FINISH"
            color: mainWindow.textMainColour
            anchors.centerIn: parent
            font.pixelSize: 15
        }
        
        MouseArea {
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.BlankCursor
            onPressed: finishButton.color = "#60228201"
            onReleased: finishButton.color = "transparent"
            onClicked: {
                // Collect current grid state
                var currentGrid = [];
                for (var i = 0; i < 9; i++) {
                    var row = [];
                    for (var j = 0; j < 9; j++) {
                        var cellIndex = i * 9 + j;
                        var cellItem = sudokuCellsRepeater.itemAt(cellIndex);
                        var cellInput = cellItem.children[0];
                        row.push(cellInput.text === "" ? 0 : parseInt(cellInput.text));
                    }
                    currentGrid.push(row);
                }
                sudokuGenerator.checkPuzzle(currentGrid);
            }
        }
    }

    // Back button
    BackButton {
        id: backButton
        anchors.bottom: borderControl.bottom
        anchors.right: parent.right
        anchors.rightMargin: 60
        visible: !sudokuGameScreen.gameStarted
        onClicked: {
            stackView.pop()
            timerIcon.y = mainWindow.height - timerIcon.height * 0.2
            isPlayScreenLoaded = true
        }
    }

    // Reset button
    Rectangle {
        id: endButton
        width: 100
        height: 40
        color: "transparent"
        radius: 5
        border.width: 2
        border.color: mainWindow.borderMainColour
        visible: sudokuGameScreen.gameStarted
        anchors.bottom: borderControl.bottom
        anchors.bottomMargin: 60
        anchors.right: parent.right
        anchors.rightMargin: 60
        
        Text {
            text: "RESET"
            color: mainWindow.textMainColour
            anchors.centerIn: parent
            font.pixelSize: 15
        }
        
        MouseArea {
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.BlankCursor
            onPressed: endButton.color = "#60228201"
            onReleased: endButton.color = "transparent"
            onClicked: {
                if (mainWindow.resetPopDisplayState) {
                    popupResetConfirmation.visible = true;
                } else {
                    resetGame();
                }
            }
        }
    }
    
    // Reset confirmation popup
    Rectangle {
        id: popupResetConfirmation
        width: 400
        height: 200
        color: "transparent"
        radius: 10
        border.color: mainWindow.borderMainColour
        border.width: 2
        anchors.centerIn: parent
        visible: false
        z: 100

        Column {
            anchors.fill: parent
            spacing: 10
            
            Text {
                text: "Are you Sure?"
                font.bold: true
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: parent.top
                anchors.topMargin: 40
                color: mainWindow.textMainColour
                font.pixelSize: 20
            }
            
            Row {
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 40
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
                        font.pixelSize: 14
                    }

                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.BlankCursor
                        onPressed: yesButton.color = "#60228201"
                        onReleased: yesButton.color = "transparent"
                        onClicked: {
                            resetGame();
                            popupResetConfirmation.visible = false;
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
                        font.pixelSize: 14
                    }

                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.BlankCursor
                        onPressed: noButton.color = "#60228201"
                        onReleased: noButton.color = "transparent"
                        onClicked: {
                            popupResetConfirmation.visible = false;
                        }
                    }
                }
            }
        }
    }

    // Game status popup
    Rectangle {
        id: popup
        width: 400
        height: 200
        color: "transparent"
        radius: 10
        border.color: mainWindow.borderMainColour
        border.width: 2
        anchors.centerIn: parent
        visible: false
        z: 99

        property bool showResumeButton: true
        property bool showCloseButton: true
        property string popupTitle: ""
        property string popupText: ""

        Column {
            anchors.fill: parent
            spacing: 10
            
            Text {
                text: popup.popupTitle
                font.bold: true
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: parent.top
                anchors.topMargin: 15
                color: mainWindow.textMainColour
                font.pixelSize: 20
            }
            
            Text {
                text: popup.popupText
                anchors.centerIn: parent
                color: mainWindow.textMainColour
                font.pixelSize: 15
            }
            
            Row {
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 15
                spacing: 20
                
                // Resume button
                Rectangle {
                    id: resumeButton
                    width: 80
                    height: 30
                    color: "transparent"
                    radius: 5
                    border.width: 1
                    border.color: mainWindow.borderMainColour
                    visible: popup.showResumeButton

                    Text {
                        text: "Resume"
                        color: mainWindow.textMainColour
                        anchors.centerIn: parent
                        font.pixelSize: 14
                    }

                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.BlankCursor
                        onPressed: resumeButton.color = "#60228201"
                        onReleased: resumeButton.color = "transparent"
                        onClicked: popup.visible = false
                    }
                }
                
                // Close button
                Rectangle {
                    id: closeButton
                    width: 80
                    height: 30
                    color: "transparent"
                    radius: 5
                    border.width: 1
                    border.color: mainWindow.borderMainColour
                    visible: popup.showCloseButton

                    Text {
                        text: "Close"
                        color: mainWindow.textMainColour
                        anchors.centerIn: parent
                        font.pixelSize: 14
                    }

                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.BlankCursor
                        onPressed: closeButton.color = "#60228201"
                        onReleased: closeButton.color = "transparent"
                        onClicked: {
                            sudokuGameScreen.selectedNumber = 0
                            mainWindow.gameTimer.running = false;
                            sudokuGameScreen.gameStarted = false;
                            startButtonShowing = true
                            popup.visible = false
                        }
                    }
                }
            }
        }
    }
    
    // Helper function to reset the game
    function resetGame() {
        sudokuGameScreen.selectedNumber = 0;
        mainWindow.gameTimer.running = false;
        mainWindow.gameTimer.seconds = 0;
        sudokuGenerator.generateSudoku(difficulty);
        mainWindow.gameTimer.running = true;
    }
}