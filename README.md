# Sudoku

A Sudoku game with a computer aesthetic built using Qt/QML.

![Retro Sudoku](https://github.com/A-Little-Mouse/Sudoku/blob/main/screenshots/main-screen.png)

## Features

- **Retro Computer Interface**: Experience Sudoku on a virtual retro computer monitor
- **Multiple Difficulty Levels**: Easy, Medium, and Hard puzzles
- **Puzzle Solver**: Built-in solver for when you're stuck
- **Game History**: Track your completed puzzles and times
- **Customizable Settings**: Adjust sound, display, and accessibility options
- **Immersive Sound Effects**: Background music and interactive sound effects <Not ATP>

## Screenshots

<table>
  <tr>
    <td><img src="https://github.com/A-Little-Mouse/Sudoku/blob/main/screenshots/main-menu.png" alt="Main Menu" width="400"/></td>
    <td><img src="https://github.com/A-Little-Mouse/Sudoku/blob/main/screenshots/play-screen.png" alt="Gameplay" width="400"/></td>
  </tr>
  <tr>
    <td><img src="https://github.com/A-Little-Mouse/Sudoku/blob/main/screenshots/solve-screen.png" alt="Solver" width="400"/></td>
    <td><img src="https://github.com/A-Little-Mouse/Sudoku/blob/main/screenshots/setting-screen.png" alt="History" width="400"/></td>
  </tr>
</table>

## Technologies Used

- **Qt 6/5**: Cross-platform application framework
- **QML**: Declarative UI language
- **C++**: Backend logic and algorithms
- **CMake**: Build system

## Game Modes

### Play Mode
Challenge yourself with Sudoku puzzles at three difficulty levels:
- **Easy**: Fewer empty cells, suitable for beginners
- **Medium**: Balanced difficulty for regular players
- **Hard**: Challenging puzzles for Sudoku experts

### Solver Mode
Input any Sudoku puzzle and let the application solve it for you. Great for learning or checking your work.

### History Mode
Review your completed puzzles, including:
- Completion time
- Difficulty level
- Date completed
- Full puzzle solution

## Installation

### Prerequisites
- Qt 6.0+ (Qt 5.15+ also supported)
- CMake 3.16+
- C++ compiler with C++17 support

## How to Play

1. **Start the Game**: Click the power button on the virtual computer
2. **Select Game Mode**: Choose "PLAY" from the main menu
3. **Select Difficulty**: Choose Easy, Medium, or Hard
4. **Playing**:
   - Click a cell and type a number (1-9)
   - Alternatively, select a number from the number display and click cells
   - Correct numbers appear in blue, incorrect in red
5. **Finishing**: Click "FINISH" to check your solution
6. **Saving**: Completed puzzles are automatically saved to your history

## Core Components

- **SudokuGenerator**: Generates and validates Sudoku puzzles
- **Solver**: Implements backtracking algorithm to solve puzzles
- **HistoryRead**: Manages puzzle history and storage
- **UI Screens**: Main, Play, Solver, History, and Settings screens

## Acknowledgments

- Sound effects from [Pixabay](https://pixabay.com/)
- Background music: Add a music as sound_1 in /AudioResources/Music/
- Inspiration from retro computing aesthetics

---

Made by BALM.
