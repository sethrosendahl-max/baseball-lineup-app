import SwiftUI

struct FieldTabView: View {
    @ObservedObject var viewModel: GameViewModel
    
    var body: some View {
        NavigationView {
            VStack {
                ScrollView {
                    VStack(spacing: 20) {
                        FieldView(viewModel: viewModel)
                        
                        Divider()
                        
                        // Bench Players
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Bench")
                                .font(.headline)
                                .padding(.horizontal)
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 12) {
                                    ForEach(viewModel.gameState.benchPlayers) { player in
                                        BenchPlayerCard(player: player)
                                            .draggable("player_\(player.id)")
                                    }
                                }
                                .padding()
                            }
                        }
                    }
                }
            }
            .navigationTitle("Field")
        }
    }
}

struct BenchPlayerCard: View {
    let player: Player
    
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
    }
}

struct FieldTabView_Previews: PreviewProvider {
    static var previews: some View {
        FieldTabView(viewModel: GameViewModel())
    }
}
