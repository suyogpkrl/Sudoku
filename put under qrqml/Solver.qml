import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import com.sudoku.solver 1.0

Item {
    id: solverScreen
    width: parent.width
    height: parent.height

    Solver {
        id: sudokuSolver
        onSudokuSolved: function(success, solution) {
            if (success) {
                for (var i = 0; i < 9; ++i) {
                    for (var j = 0; j < 9; ++j) {
                        var cellIndex = i * 9 + j;
                        var cellItem = sudokuCellsRepeater.itemAt(cellIndex);
                        var cellInput = cellItem.children[0];
                        cellInput.text = solution[i][j].toString();
                        cellInput.color = "blue";
                    }
                }
            } else {
                // Display a message to the user that the puzzle is unsolvable
                console.log("Puzzle is unsolvable!");
            }
        }
    }

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

                TextInput {
                    id: cellInput
                    anchors.fill: parent
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    font.pixelSize: 20
                    color: "white"
                    validator: IntValidator { bottom: 1; top: 9; }
                }
            }
        }
    }

    Button {
        text: "Solve"
        anchors.left: parent.left
        anchors.bottom: parent.bottom
        anchors.leftMargin: 40
        anchors.bottomMargin: 80 // Moved above Reset button
        onClicked: {
            var grid = [];
            for (var i = 0; i < 9; ++i) {
                var row = [];
                for (var j = 0; j < 9; ++j) {
                    var cellIndex = i * 9 + j;
                    var cellItem = sudokuCellsRepeater.itemAt(cellIndex);
                    var cellInput = cellItem.children[0];
                    var value = parseInt(cellInput.text, 10);
                    row.push(isNaN(value) ? 0 : value);
                }
                grid.push(row);
            }
            sudokuSolver.solvePuzzle(grid);
        }
    }

    Button {
        text: "Reset"
        anchors.left: parent.left // Align with Solve button
        anchors.bottom: parent.bottom
        anchors.leftMargin: 40
        anchors.bottomMargin: 40 // Below Solve button
        onClicked: {
            for (var i = 0; i < 9; ++i) {
                for (var j = 0; j < 9; ++j) {
                    var cellIndex = i * 9 + j;
                    var cellItem = sudokuCellsRepeater.itemAt(cellIndex);
                    var cellInput = cellItem.children[0];
                    cellInput.text = "";
                    cellInput.color = "white";
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
