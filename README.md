# Baseball Lineup App

An iOS application for managing baseball lineups and field positioning built with Swift and SwiftUI.

## Features

- **Batting Order**: Display and manage up to 12 players in batting order
- **Scoreboard**: Easy-to-use scoreboard for tracking score and team names
- **Field Positioning**: Drag-and-drop player positioning on a baseball field
- **Bench Players**: 3 bench player slots for substitutions
- **Player Management**: Add, edit, and manage player information (name and number)

## Requirements

- iOS 15.0 or later
- Xcode 13.0 or later
- Swift 5.5 or later

## Usage

1. Add players to your lineup
2. Enter team names and set initial scores in the scoreboard
3. Drag and drop players from the bench to field positions
4. Update score during the game

## Architecture

- **Models**: Player, Team, GameState
- **Views**: ContentView, ScoreboardView, BattingOrderView, FieldView
- **ViewModels**: GameViewModel for state management
