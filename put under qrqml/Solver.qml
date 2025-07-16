import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import com.sudoku.solver 1.0

Item {
    id: solverScreen
    width: parent.width
    height: parent.height

    property int selectedNumber: 0 // Stores the currently selected number for input

    function isGridCompletelyEmpty() {
        for (var i = 0; i < sudokuCellsRepeater.count; ++i) {
            var cellItem = sudokuCellsRepeater.itemAt(i);
            var cellInput = cellItem.children[0];
            if (cellInput.text !== "") {
                return false;
            }
        }
        return true;
    }

    Component.onCompleted: {
        solverScreen.forceActiveFocus(); // Ensure item can receive key events
        // Initial check for button visibility
        solveButton.visible = !isGridCompletelyEmpty();
        resetButton.visible = !isGridCompletelyEmpty();
    }

    Keys.onPressed: {
        if (event.key >= Qt.Key_1 && event.key <= Qt.Key_9) {
            selectedNumber = event.key - Qt.Key_0;
            event.accepted = true;
        } else if (event.key === Qt.Key_Delete || event.key === Qt.Key_Backspace) {
            selectedNumber = 0;
            event.accepted = true;
        }
    }

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
                        cellInput.color = "white";
                    }
                }
            } else {
                // Display a message to the user that the puzzle is unsolvable
                console.log("Puzzle is unsolvable!");
                unsolvableText.visible = true;
            }
        }
    }

    Rectangle {
        id: selectedNumberDisplay
        width: 140  // Adjust size as needed
        height: width  // Maintain 1:1 aspect ratio
        radius: 5  // Slightly rounded corners
        color: selectedNumber === 0 ? "transparent" : mainWindow.textMainColour
        border.color: mainWindow.borderMainColour
        border.width: 2
        anchors.right: parent.right
        anchors.top: borderControl.top
        anchors.rightMargin: 60

        Text {
            id: numberText
            text: solverScreen.selectedNumber === 0 ? "SELECT" : solverScreen.selectedNumber
            color: solverScreen.selectedNumber === 0? mainWindow.textMainColour : "#455663"
            font {
                pixelSize: solverScreen.selectedNumber === 0? 36 : 80
                bold: true
            }
            anchors.centerIn: parent
        }
    }

    Text {
        id: unsolvableText
        text: "Invalid Puzzle"
        color: mainWindow.textMainColour
        font.pixelSize: 24
        anchors.right: parent.right
        anchors.rightMargin: 60
        anchors.verticalCenter: parent.verticalCenter
        visible: false
    }

    Rectangle{
    id:borderControl
    anchors.left: parent.left
    anchors.leftMargin: 40
    anchors.verticalCenter: parent.verticalCenter
    width: Math.min(parent.width, parent.height) * 0.8
    height: width
    color:"transparent"
    border.width: 2
    border.color: mainWindow.borderMainColour

    Grid {
        id: sudokuGrid
        columns: 9
        rows: 9
        spacing: 0
        width: parent.width
        height: parent.height
        anchors.fill: parent

        Repeater {
            id: sudokuCellsRepeater
            model: 81
            Rectangle {
                width: sudokuGrid.width / 9
                height: sudokuGrid.height / 9
                color: "transparent"
                border.width: 1
                border.color: mainWindow.borderMainColour

                TextInput {
                    id: cellInput
                    anchors.fill: parent
                    anchors.margins: -1 // This compensates for the border width
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    font.pixelSize: 20
                    color: mainWindow.textMainColour
                    readOnly: true // Make it read-only, input is via selectedNumber
                    validator: IntValidator { bottom: 1; top: 9; }
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        if (solverScreen.selectedNumber !== 0) {
                            cellInput.text = solverScreen.selectedNumber.toString();
                        } else {
                            cellInput.text = ""; // Clear the cell if 0 is selected
                        }
                        // Update button visibility after a cell is modified
                        solveButton.visible = !solverScreen.isGridCompletelyEmpty();
                        resetButton.visible = !solverScreen.isGridCompletelyEmpty();
                    }
                }
            }
        }
    }
    }

    Rectangle {
        id: solveButton
        width: 100
        height: 40
        color: "transparent"
        radius: 5
        border.width: 2
        border.color: mainWindow.borderMainColour
        anchors.right: parent.right
        anchors.bottom: borderControl.bottom
        anchors.rightMargin: 60
        anchors.bottomMargin: 120

        Text{
            text: "SOLVE"
            color: mainWindow.textMainColour
            anchors.centerIn: parent
            font {
                //family: quicksandMedium.name
                pixelSize: 15
            }
        }
        MouseArea{
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.BlankCursor
            onPressed: solveButton.color = "#60228201"
            onReleased: solveButton.color ="transparent"
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
    }

    Rectangle {
        id: resetButton
        width: 100
        height: 40
        color: "transparent"
        radius: 5
        border.width: 2
        border.color: mainWindow.borderMainColour
        anchors.right: parent.right
        anchors.bottom: borderControl.bottom
        anchors.rightMargin: 60
        anchors.bottomMargin: 60

        Text{
            text: "RESET"
            color: mainWindow.textMainColour
            anchors.centerIn: parent
            font {
                //family: quicksandMedium.name
                pixelSize: 15
            }
        }
        MouseArea{
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.BlankCursor
            onPressed: resetButton.color = "#60228201"
            onReleased: resetButton.color ="transparent"
            onClicked: {
                unsolvableText.visible = false;
                solveButton.visible = false;
                resetButton.visible = false;
                solverScreen.selectedNumber = 0; // Reset selected number
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
    }

    BackButton {
        anchors.bottom: borderControl.bottom
        anchors.right: parent.right
        anchors.rightMargin: 60
        onClicked: {
            stackView.pop()
        }
    }
}
