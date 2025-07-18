/**
 * Solver.qml
 * 
 * A screen that allows users to input a Sudoku puzzle and solve it.
 * Uses the C++ Solver class to find solutions to user-provided puzzles.
 */

import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import com.sudoku.solver 1.0

Item {
    id: solverScreen
    width: parent.width
    height: parent.height

    // Currently selected number for input (0 means delete)
    property int selectedNumber: 0
    
    // Cache for button visibility to avoid repeated calculations
    property bool gridEmpty: true

    /**
     * Checks if the grid is completely empty
     * @return {boolean} True if all cells are empty, false otherwise
     */
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

    // Initialize the screen
    Component.onCompleted: {
        solverScreen.forceActiveFocus(); // Ensure item can receive key events
        // Initial check for button visibility
        gridEmpty = isGridCompletelyEmpty();
        updateButtonVisibility();
    }

    // Handle keyboard input
    Keys.onPressed: function(event) {
        if (event.key >= Qt.Key_1 && event.key <= Qt.Key_9) {
            selectedNumber = event.key - Qt.Key_0;
            event.accepted = true;
        } else if (event.key === Qt.Key_Delete || event.key === Qt.Key_Backspace) {
            selectedNumber = 0;
            event.accepted = true;
        }
    }

    // Update button visibility based on grid state
    function updateButtonVisibility() {
        solveButton.visible = !gridEmpty;
        resetButton.visible = !gridEmpty;
    }

    // Solver component
    Solver {
        id: sudokuSolver
        
        // Handle solver results
        onSudokuSolved: function(success, solution) {
            if (success) {
                // Fill the grid with the solution
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
                // Display a message that the puzzle is unsolvable
                console.log("Puzzle is unsolvable!");
                unsolvableText.visible = true;
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
            text: solverScreen.selectedNumber === 0 ? "SELECT" : solverScreen.selectedNumber
            color: solverScreen.selectedNumber === 0 ? mainWindow.textMainColour : "#455663"
            font {
                pixelSize: solverScreen.selectedNumber === 0 ? 36 : 80
                bold: true
            }
            anchors.centerIn: parent
        }
    }

    // Error message for unsolvable puzzles
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

                    // Cell input field
                    TextInput {
                        id: cellInput
                        anchors.fill: parent
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        font.pixelSize: 20
                        color: mainWindow.textMainColour
                        readOnly: true // Make it read-only, input is via selectedNumber
                        validator: IntValidator { bottom: 1; top: 9; }
                    }

                    // Cell click handler
                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            var wasEmpty = cellInput.text === "";
                            
                            if (solverScreen.selectedNumber !== 0) {
                                cellInput.text = solverScreen.selectedNumber.toString();
                            } else {
                                cellInput.text = ""; // Clear the cell if 0 is selected
                            }
                            
                            // Only update button visibility if the empty state changed
                            var isEmpty = cellInput.text === "";
                            if (wasEmpty !== isEmpty) {
                                gridEmpty = isGridCompletelyEmpty();
                                updateButtonVisibility();
                            }
                            
                            // Hide error message when grid is modified
                            unsolvableText.visible = false;
                        }
                    }
                }
            }
        }
    }

    // Solve button
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
        visible: false // Initially hidden

        Text {
            text: "SOLVE"
            color: mainWindow.textMainColour
            anchors.centerIn: parent
            font.pixelSize: 15
        }
        
        MouseArea {
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.BlankCursor
            onPressed: solveButton.color = "#60228201"
            onReleased: solveButton.color = "transparent"
            onClicked: {
                // Collect grid data
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
                
                // Solve the puzzle
                sudokuSolver.solvePuzzle(grid);
            }
        }
    }

    // Reset button
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
        visible: false // Initially hidden

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
            onPressed: resetButton.color = "#60228201"
            onReleased: resetButton.color = "transparent"
            onClicked: {
                resetGrid();
            }
        }
    }

    // Back button
    BackButton {
        anchors.bottom: borderControl.bottom
        anchors.right: parent.right
        anchors.rightMargin: 60
        onClicked: {
            stackView.pop()
        }
    }
    
    /**
     * Resets the grid to empty state
     */
    function resetGrid() {
        unsolvableText.visible = false;
        solverScreen.selectedNumber = 0; // Reset selected number
        
        // Clear all cells
        for (var i = 0; i < sudokuCellsRepeater.count; ++i) {
            var cellItem = sudokuCellsRepeater.itemAt(i);
            var cellInput = cellItem.children[0];
            cellInput.text = "";
            cellInput.color = "white";
        }
        
        // Update state and button visibility
        gridEmpty = true;
        updateButtonVisibility();
    }
}