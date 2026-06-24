import SwiftUI

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

struct LineupTabView_Previews: PreviewProvider {
    static var previews: some View {
        LineupTabView(viewModel: GameViewModel())
    }
}
