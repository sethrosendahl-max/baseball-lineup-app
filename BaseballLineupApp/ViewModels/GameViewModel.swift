import Foundation

class GameViewModel: ObservableObject {
    @Published var gameState: GameState = GameState()
    
    init() {
        // Initialize with sample players
        setupSamplePlayers()
    }
    
    func setupSamplePlayers() {
        for i in 1...12 {
            let player = Player(name: "Player \(i)", number: i)
            gameState.addPlayer(player)
        }
    }
    
    func addPlayer(name: String, number: Int) {
        let player = Player(name: name, number: number)
        gameState.addPlayer(player)
    }
    
    func removePlayer(_ player: Player) {
        gameState.removePlayer(player)
    }
    
    func assignPlayerToField(_ player: Player, position: FieldPosition) {
        gameState.assignPlayerToPosition(player, position: position)
    }
    
    func assignPlayerToBench(_ player: Player) {
        gameState.assignPlayerToPosition(player, position: nil)
    }
    
    func updateTeamName(_ name: String, isHome: Bool) {
        if isHome {
            gameState.homeTeamName = name
        } else {
            gameState.awayTeamName = name
        }
    }
    
    func updateScore(isHome: Bool, newScore: Int) {
        if isHome {
            gameState.homeScore = newScore
        } else {
            gameState.awayScore = newScore
        }
    }
    
    func incrementScore(isHome: Bool) {
        if isHome {
            gameState.homeScore += 1
        } else {
            gameState.awayScore += 1
        }
    }
    
    func nextInning() {
        gameState.inning += 1
        gameState.isHomeTeamBatting.toggle()
    }
}
