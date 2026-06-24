import SwiftUI

// MARK: - Models
struct Player: Identifiable, Equatable {
    let id: UUID
    var name: String
    var number: Int
    var position: FieldPosition?
    var isBenched: Bool = true
    
    init(id: UUID = UUID(), name: String, number: Int, position: FieldPosition? = nil, isBenched: Bool = true) {
        self.id = id
        self.name = name
        self.number = number
        self.position = position
        self.isBenched = isBenched
    }
}

enum FieldPosition: String, CaseIterable {
    case pitcher = "Pitcher"
    case catcher = "Catcher"
    case firstBase = "1B"
    case secondBase = "2B"
    case thirdBase = "3B"
    case shortstop = "SS"
    case leftField = "LF"
    case centerField = "CF"
    case rightField = "RF"
    
    var displayName: String {
        self.rawValue
    }
}

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

// MARK: - ViewModel
class GameViewModel: ObservableObject {
    @Published var gameState: GameState = GameState()
    
    init() {
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

// MARK: - Main App
@main
struct BaseballLineupApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

// MARK: - Content View
struct ContentView: View {
    @StateObject private var viewModel = GameViewModel()
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            GameTabView(viewModel: viewModel)
                .tabItem {
                    Label("Game", systemImage: "baseball")
                }
                .tag(0)
            
            LineupTabView(viewModel: viewModel)
                .tabItem {
                    Label("Lineup", systemImage: "list.number")
                }
                .tag(1)
            
            FieldTabView(viewModel: viewModel)
                .tabItem {
                    Label("Field", systemImage: "square.grid.2x2")
                }
                .tag(2)
        }
    }
}

// MARK: - Scoreboard View
struct ScoreboardView: View {
    @ObservedObject var viewModel: GameViewModel
    @State private var isEditingTeamNames = false
    
    var body: some View {
        VStack(spacing: 16) {
            HStack(spacing: 20) {
                TeamNameField(
                    label: "Home",
                    text: $viewModel.gameState.homeTeamName,
                    isEditing: isEditingTeamNames
                )
                
                Divider()
                
                TeamNameField(
                    label: "Away",
                    text: $viewModel.gameState.awayTeamName,
                    isEditing: isEditingTeamNames
                )
                
                Button(action: { isEditingTeamNames.toggle() }) {
                    Image(systemName: isEditingTeamNames ? "checkmark.circle.fill" : "pencil.circle")
                        .font(.title2)
                }
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(8)
            
            HStack(spacing: 40) {
                ScoreCard(
                    teamName: viewModel.gameState.homeTeamName,
                    score: viewModel.gameState.homeScore,
                    onIncrement: { viewModel.incrementScore(isHome: true) },
                    onDecrement: {
                        if viewModel.gameState.homeScore > 0 {
                            viewModel.gameState.homeScore -= 1
                        }
                    }
                )
                
                Divider()
                    .frame(height: 80)
                
                ScoreCard(
                    teamName: viewModel.gameState.awayTeamName,
                    score: viewModel.gameState.awayScore,
                    onIncrement: { viewModel.incrementScore(isHome: false) },
                    onDecrement: {
                        if viewModel.gameState.awayScore > 0 {
                            viewModel.gameState.awayScore -= 1
                        }
                    }
                )
            }
            .padding()
            
            HStack {
                Text("Inning: \(viewModel.gameState.inning)")
                    .font(.headline)
                Spacer()
                Text(viewModel.gameState.isHomeTeamBatting ? "Home Batting" : "Away Batting")
                    .font(.headline)
                    .foregroundColor(.blue)
                Spacer()
                Button(action: { viewModel.nextInning() }) {
                    Text("Next Inning")
                        .font(.caption)
                        .padding(6)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(4)
                }
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(8)
        }
        .padding()
    }
}

struct TeamNameField: View {
    let label: String
    @Binding var text: String
    let isEditing: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(label)
                .font(.caption)
                .foregroundColor(.gray)
            
            if isEditing {
                TextField(label, text: $text)
                    .textFieldStyle(.roundedBorder)
            } else {
                Text(text.isEmpty ? label : text)
                    .font(.headline)
            }
        }
    }
}

struct ScoreCard: View {
    let teamName: String
    let score: Int
    let onIncrement: () -> Void
    let onDecrement: () -> Void
    
    var body: some View {
        VStack(spacing: 12) {
            Text(teamName)
                .font(.headline)
                .lineLimit(1)
            
            Text("\(score)")
                .font(.system(size: 48, weight: .bold, design: .default))
            
            HStack(spacing: 8) {
                Button(action: onDecrement) {
                    Image(systemName: "minus.circle.fill")
                        .font(.title2)
                }
                
                Button(action: onIncrement) {
                    Image(systemName: "plus.circle.fill")
                        .font(.title2)
                }
            }
            .foregroundColor(.blue)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(8)
    }
}

// MARK: - Batting Order View
struct BattingOrderView: View {
    @ObservedObject var viewModel: GameViewModel
    
    var battingOrder: [Player] {
        viewModel.gameState.players.sorted {
            ($0.number) < ($1.number)
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Batting Order")
                .font(.headline)
                .padding(.horizontal)
            
            ScrollView {
                VStack(spacing: 0) {
                    ForEach(Array(battingOrder.enumerated()), id: \.element.id) { index, player in
                        BattingOrderRow(
                            order: index + 1,
                            player: player,
                            onTap: {}
                        )
                        
                        if index < battingOrder.count - 1 {
                            Divider()
                                .padding(.horizontal)
                        }
                    }
                }
            }
        }
    }
}

struct BattingOrderRow: View {
    let order: Int
    let player: Player
    let onTap: () -> Void
    
    var body: some View {
        HStack(spacing: 12) {
            Text("#\(order)")
                .font(.headline)
                .frame(width: 30)
                .foregroundColor(.blue)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(player.name)
                    .font(.body)
                    .fontWeight(.semibold)
                
                if let position = player.position {
                    Text(position.displayName)
                        .font(.caption)
                        .foregroundColor(.gray)
                } else {
                    Text("Bench")
                        .font(.caption)
                        .foregroundColor(.orange)
                }
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 2) {
                Text("#\(player.number)")
                    .font(.headline)
                    .foregroundColor(.blue)
            }
        }
        .padding(.vertical, 12)
        .padding(.horizontal)
        .contentShape(Rectangle())
        .onTapGesture(perform: onTap)
    }
}

// MARK: - Field View
struct FieldView: View {
    @ObservedObject var viewModel: GameViewModel
    
    var body: some View {
        VStack {
            ScrollView {
                VStack(spacing: 20) {
                    VStack(spacing: 20) {
                        Text("Field Positions")
                            .font(.headline)
                        
                        HStack(spacing: 80) {
                            FieldPositionView(
                                position: .pitcher,
                                player: viewModel.gameState.fieldPlayers.first(where: { $0.position == .pitcher }),
                                onTap: {
                                    if let player = viewModel.gameState.fieldPlayers.first(where: { $0.position == .pitcher }) {
                                        viewModel.assignPlayerToBench(player)
                                    }
                                }
                            )
                            
                            FieldPositionView(
                                position: .catcher,
                                player: viewModel.gameState.fieldPlayers.first(where: { $0.position == .catcher }),
                                onTap: {
                                    if let player = viewModel.gameState.fieldPlayers.first(where: { $0.position == .catcher }) {
                                        viewModel.assignPlayerToBench(player)
                                    }
                                }
                            )
                        }
                        
                        HStack(spacing: 30) {
                            FieldPositionView(
                                position: .thirdBase,
                                player: viewModel.gameState.fieldPlayers.first(where: { $0.position == .thirdBase }),
                                onTap: {
                                    if let player = viewModel.gameState.fieldPlayers.first(where: { $0.position == .thirdBase }) {
                                        viewModel.assignPlayerToBench(player)
                                    }
                                }
                            )
                            
                            FieldPositionView(
                                position: .shortstop,
                                player: viewModel.gameState.fieldPlayers.first(where: { $0.position == .shortstop }),
                                onTap: {
                                    if let player = viewModel.gameState.fieldPlayers.first(where: { $0.position == .shortstop }) {
                                        viewModel.assignPlayerToBench(player)
                                    }
                                }
                            )
                            
                            FieldPositionView(
                                position: .secondBase,
                                player: viewModel.gameState.fieldPlayers.first(where: { $0.position == .secondBase }),
                                onTap: {
                                    if let player = viewModel.gameState.fieldPlayers.first(where: { $0.position == .secondBase }) {
                                        viewModel.assignPlayerToBench(player)
                                    }
                                }
                            )
                            
                            FieldPositionView(
                                position: .firstBase,
                                player: viewModel.gameState.fieldPlayers.first(where: { $0.position == .firstBase }),
                                onTap: {
                                    if let player = viewModel.gameState.fieldPlayers.first(where: { $0.position == .firstBase }) {
                                        viewModel.assignPlayerToBench(player)
                                    }
                                }
                            )
                        }
                        
                        HStack(spacing: 40) {
                            FieldPositionView(
                                position: .leftField,
                                player: viewModel.gameState.fieldPlayers.first(where: { $0.position == .leftField }),
                                onTap: {
                                    if let player = viewModel.gameState.fieldPlayers.first(where: { $0.position == .leftField }) {
                                        viewModel.assignPlayerToBench(player)
                                    }
                                }
                            )
                            
                            FieldPositionView(
                                position: .centerField,
                                player: viewModel.gameState.fieldPlayers.first(where: { $0.position == .centerField }),
                                onTap: {
                                    if let player = viewModel.gameState.fieldPlayers.first(where: { $0.position == .centerField }) {
                                        viewModel.assignPlayerToBench(player)
                                    }
                                }
                            )
                            
                            FieldPositionView(
                                position: .rightField,
                                player: viewModel.gameState.fieldPlayers.first(where: { $0.position == .rightField }),
                                onTap: {
                                    if let player = viewModel.gameState.fieldPlayers.first(where: { $0.position == .rightField }) {
                                        viewModel.assignPlayerToBench(player)
                                    }
                                }
                            )
                        }
                    }
                    .padding()
                    .background(Color(red: 0.0, green: 0.5, blue: 0.0).opacity(0.1))
                    .cornerRadius(8)
                    
                    Divider()
                    
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Bench Players")
                            .font(.headline)
                            .padding(.horizontal)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 12) {
                                ForEach(viewModel.gameState.benchPlayers) { player in
                                    BenchPlayerCard(
                                        player: player,
                                        onTap: {
                                            // Show position picker
                                        }
                                    )
                                }
                            }
                            .padding()
                        }
                    }
                }
            }
        }
    }
}

struct FieldPositionView: View {
    let position: FieldPosition
    let player: Player?
    let onTap: () -> Void
    
    var body: some View {
        VStack(spacing: 4) {
            if let player = player {
                VStack(spacing: 2) {
                    Text(player.name)
                        .font(.caption2)
                        .fontWeight(.semibold)
                        .lineLimit(1)
                    Text("#\(player.number)")
                        .font(.caption2)
                }
                .frame(width: 60, height: 60)
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(30)
                .onTapGesture(perform: onTap)
            } else {
                RoundedRectangle(cornerRadius: 30)
                    .strokeBorder(style: StrokeStyle(lineWidth: 2, dash: [5]))
                    .frame(width: 60, height: 60)
                    .foregroundColor(.gray)
            }
            
            Text(position.displayName)
                .font(.caption)
                .fontWeight(.semibold)
        }
    }
}

struct BenchPlayerCard: View {
    let player: Player
    let onTap: () -> Void
    
    var body: some View {
        VStack(spacing: 4) {
            Text(player.name)
                .font(.caption)
                .fontWeight(.semibold)
                .lineLimit(1)
            
            Text("#\(player.number)")
                .font(.caption2)
                .foregroundColor(.blue)
        }
        .frame(width: 80, height: 80)
        .background(Color.orange)
        .foregroundColor(.white)
        .cornerRadius(8)
        .onTapGesture(perform: onTap)
    }
}

// MARK: - Tab Views
struct GameTabView: View {
    @ObservedObject var viewModel: GameViewModel
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                ScoreboardView(viewModel: viewModel)
                    .frame(maxHeight: .infinity, alignment: .top)
                
                Divider()
                
                BattingOrderView(viewModel: viewModel)
                    .frame(maxHeight: .infinity)
            }
            .navigationTitle("Game")
        }
    }
}

struct LineupTabView: View {
    @ObservedObject var viewModel: GameViewModel
    @State private var showAddPlayerSheet = false
    @State private var newPlayerName = ""
    @State private var newPlayerNumber = ""
    
    var body: some View {
        NavigationView {
            VStack {
                List {
                    Section(header: Text("Field Players (\(viewModel.gameState.fieldPlayers.count))")) {
                        ForEach(viewModel.gameState.fieldPlayers) { player in
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(player.name)
                                        .fontWeight(.semibold)
                                    if let position = player.position {
                                        Text(position.displayName)
                                            .font(.caption)
                                            .foregroundColor(.gray)
                                    }
                                }
                                Spacer()
                                Text("#\(player.number)")
                                    .fontWeight(.semibold)
                                    .foregroundColor(.blue)
                            }
                        }
                        .onDelete { indexSet in
                            for index in indexSet {
                                viewModel.removePlayer(viewModel.gameState.fieldPlayers[index])
                            }
                        }
                    }
                    
                    Section(header: Text("Bench Players (\(viewModel.gameState.benchPlayers.count))")) {
                        ForEach(viewModel.gameState.benchPlayers) { player in
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(player.name)
                                        .fontWeight(.semibold)
                                }
                                Spacer()
                                Text("#\(player.number)")
                                    .fontWeight(.semibold)
                                    .foregroundColor(.blue)
                            }
                        }
                        .onDelete { indexSet in
                            for index in indexSet {
                                viewModel.removePlayer(viewModel.gameState.benchPlayers[index])
                            }
                        }
                    }
                }
                
                Button(action: { showAddPlayerSheet = true }) {
                    HStack {
                        Image(systemName: "plus.circle.fill")
                        Text("Add Player")
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                }
                .padding()
            }
            .navigationTitle("Lineup")
            .sheet(isPresented: $showAddPlayerSheet) {
                AddPlayerSheet(
                    isPresented: $showAddPlayerSheet,
                    name: $newPlayerName,
                    number: $newPlayerNumber,
                    onAdd: {
                        if !newPlayerName.isEmpty, let number = Int(newPlayerNumber) {
                            viewModel.addPlayer(name: newPlayerName, number: number)
                            newPlayerName = ""
                            newPlayerNumber = ""
                            showAddPlayerSheet = false
                        }
                    }
                )
            }
        }
    }
}

struct AddPlayerSheet: View {
    @Binding var isPresented: Bool
    @Binding var name: String
    @Binding var number: String
    let onAdd: () -> Void
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Player Information")) {
                    TextField("Player Name", text: $name)
                    TextField("Jersey Number", text: $number)
                        .keyboardType(.numberPad)
                }
            }
            .navigationTitle("Add Player")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        isPresented = false
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Add") {
                        onAdd()
                    }
                    .disabled(name.isEmpty || number.isEmpty)
                }
            }
        }
    }
}

struct FieldTabView: View {
    @ObservedObject var viewModel: GameViewModel
    
    var body: some View {
        NavigationView {
            FieldView(viewModel: viewModel)
                .navigationTitle("Field")
        }
    }
}

#Preview {
    ContentView()
}
