import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import com.sudoku.generator 1.0

Item {
    id: sudokuGameScreen
    width: parent.width
    height: parent.height

    property int difficulty: 1 // 1: Easy, 2: Medium, 3: Hard
    property var sudokuPuzzle: []

    SudokuGenerator {
        id: sudokuGenerator
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
    }

    // Timer
    Text {
        id: timerText
        text: "00:00"
        color: "white"
        font.pixelSize: 24
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.topMargin: 40
        anchors.leftMargin: 40

        Timer {
            id: gameTimer
            interval: 1000
            running: false
            repeat: true
            property int seconds: 0
            onTriggered: {
                seconds++;
                var minutes = Math.floor(seconds / 60);
                var remainingSeconds = seconds % 60;
                timerText.text = Qt.formatTime(new Date(0, 0, 0, 0, minutes, remainingSeconds), "mm:ss");
            }
        }
    }

    Column {
        anchors.top: timerText.bottom
        anchors.left: parent.left
        anchors.topMargin: 20
        anchors.leftMargin: 40
        spacing: 10

        Button {
            id: difficultyButton
            text: "Easy"
            onClicked: {
                if (difficulty === 1) {
                    difficulty = 2;
                    text = "Medium";
                } else if (difficulty === 2) {
                    difficulty = 3;
                    text = "Hard";
                } else {
                    difficulty = 1;
                    text = "Easy";
                }
            }
        }

        Button {
            id: startButton
            text: "Start"
            onClicked: {
                sudokuGenerator.generateSudoku(difficulty);
                gameTimer.running = true;
            }
        }
    }

    // Sudoku Grid (9x9)
    GridLayout {
        id: sudokuGrid
        columns: 9
        rows: 9
        anchors.centerIn: parent
        width: Math.min(parent.width, parent.height) * 0.8
        height: width

        Repeater {
            id: sudokuCellsRepeater
            model: 81
            Rectangle {
                width: sudokuGrid.width / 9
                height: sudokuGrid.height / 9
                color: "#20FFFFFF"
                border.width: 1
                border.color: "gray"

                property bool isGiven: false
                property bool isCorrect: false

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

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        cellInput.focus = true;
                    }
                }
            }
        }
    }

    BackButton {
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        anchors.margins: 40
        onClicked: {
            stackView.pop()
        }
    }
}