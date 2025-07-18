# Retro Sudoku

A nostalgic Sudoku game with a retro computer aesthetic built using Qt/QML.

![Retro Sudoku](https://github.com/yourusername/retro-sudoku/raw/main/screenshots/main-screen.png)

## Features

- **Retro Computer Interface**: Experience Sudoku on a virtual retro computer monitor
- **Multiple Difficulty Levels**: Easy, Medium, and Hard puzzles
- **Puzzle Solver**: Built-in solver for when you're stuck
- **Game History**: Track your completed puzzles and times
- **Customizable Settings**: Adjust sound, display, and accessibility options
- **Immersive Sound Effects**: Background music and interactive sound effects

## Screenshots

<table>
  <tr>
    <td><img src="https://github.com/yourusername/retro-sudoku/raw/main/screenshots/main-menu.png" alt="Main Menu" width="400"/></td>
    <td><img src="https://github.com/yourusername/retro-sudoku/raw/main/screenshots/gameplay.png" alt="Gameplay" width="400"/></td>
  </tr>
  <tr>
    <td><img src="https://github.com/yourusername/retro-sudoku/raw/main/screenshots/solver.png" alt="Solver" width="400"/></td>
    <td><img src="https://github.com/yourusername/retro-sudoku/raw/main/screenshots/history.png" alt="History" width="400"/></td>
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

### Building from Source

1. Clone the repository:
```bash
git clone https://github.com/yourusername/retro-sudoku.git
cd retro-sudoku
```

2. Create a build directory:
```bash
mkdir build && cd build
```

3. Configure with CMake:
```bash
cmake ..
```

4. Build the project:
```bash
cmake --build .
```

5. Run the application:
```bash
./RetroSudoku
```

### Pre-built Binaries

Pre-built binaries are available for:
- Windows
- macOS
- Linux

Download from the [Releases](https://github.com/yourusername/retro-sudoku/releases) page.

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

## Project Structure

```
QT_project/
├── AudioResources/       # Sound effects and music
├── ImgResources/         # UI images and graphics
├── *.cpp, *.h            # C++ backend files
├── *.qml                 # QML UI files
├── CMakeLists.txt        # CMake build configuration
└── qml.qrc               # Resource collection file
```

## Core Components

- **SudokuGenerator**: Generates and validates Sudoku puzzles
- **Solver**: Implements backtracking algorithm to solve puzzles
- **HistoryRead**: Manages puzzle history and storage
- **UI Screens**: Main, Play, Solver, History, and Settings screens

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgments

- Sound effects from [Freesound](https://freesound.org/)
- Background music: "Glass Beans" by Mahal EP
- Inspiration from retro computing aesthetics

---

Made with by BALM.