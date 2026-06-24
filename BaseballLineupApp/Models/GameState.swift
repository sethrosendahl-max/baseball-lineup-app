import Foundation

struct GameState {
    var homeTeamName: String = "Home"
    var awayTeamName: String = "Away"
    var homeScore: Int = 0
    var awayScore: Int = 0
    var inning: Int = 1
    var isHomeTeamBatting: Bool = true
    var players: [Player] = []
    var benchPlayers: [Player] {
        players.filter { $0.isBenched }
    }
    var fieldPlayers: [Player] {
        players.filter { !$0.isBenched }
    }
    
    mutating func addPlayer(_ player: Player) {
        players.append(player)
    }
    
    mutating func removePlayer(_ player: Player) {
        players.removeAll { $0.id == player.id }
    }
    
    mutating func updatePlayer(_ player: Player) {
        if let index = players.firstIndex(where: { $0.id == player.id }) {
            players[index] = player
        }
    }
    
    mutating func assignPlayerToPosition(_ player: Player, position: FieldPosition?) {
        var updatedPlayer = player
        updatedPlayer.position = position
        updatedPlayer.isBenched = position == nil
        updatePlayer(updatedPlayer)
    }
}
