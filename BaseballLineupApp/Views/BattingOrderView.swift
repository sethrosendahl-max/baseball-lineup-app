import SwiftUI

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

struct BattingOrderView_Previews: PreviewProvider {
    static var previews: some View {
        BattingOrderView(viewModel: GameViewModel())
    }
}
