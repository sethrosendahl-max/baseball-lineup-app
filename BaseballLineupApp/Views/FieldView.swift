import SwiftUI

struct FieldView: View {
    @ObservedObject var viewModel: GameViewModel
    @State private var draggedPlayer: Player?
    
    var body: some View {
        ZStack {
            // Field background
            Canvas { context in
                // Draw baseball field diamond
                var path = Path()
                let center = CGPoint(x: 400, y: 400)
                let baseDistance: CGFloat = 100
                
                // Draw bases
                path.move(to: CGPoint(x: center.x, y: center.y - baseDistance))
                path.addLine(to: CGPoint(x: center.x + baseDistance, y: center.y))
                path.addLine(to: CGPoint(x: center.x, y: center.y + baseDistance))
                path.addLine(to: CGPoint(x: center.x - baseDistance, y: center.y))
                path.closeSubpath()
                
                context.stroke(path, with: .color(.green), lineWidth: 2)
            }
            .frame(height: 600)
            .background(Color(red: 0.0, green: 0.5, blue: 0.0).opacity(0.3))
            
            VStack {
                // Field positions
                VStack(spacing: 20) {
                    // Pitcher and Catcher
                    HStack(spacing: 80) {
                        FieldPositionView(
                            position: .pitcher,
                            player: viewModel.gameState.fieldPlayers.first(where: { $0.position == .pitcher }),
                            onDrop: { player in
                                viewModel.assignPlayerToField(player, position: .pitcher)
                            }
                        )
                        
                        FieldPositionView(
                            position: .catcher,
                            player: viewModel.gameState.fieldPlayers.first(where: { $0.position == .catcher }),
                            onDrop: { player in
                                viewModel.assignPlayerToField(player, position: .catcher)
                            }
                        )
                    }
                    
                    // Infielders
                    HStack(spacing: 30) {
                        FieldPositionView(
                            position: .thirdBase,
                            player: viewModel.gameState.fieldPlayers.first(where: { $0.position == .thirdBase }),
                            onDrop: { player in
                                viewModel.assignPlayerToField(player, position: .thirdBase)
                            }
                        )
                        
                        FieldPositionView(
                            position: .shortstop,
                            player: viewModel.gameState.fieldPlayers.first(where: { $0.position == .shortstop }),
                            onDrop: { player in
                                viewModel.assignPlayerToField(player, position: .shortstop)
                            }
                        )
                        
                        FieldPositionView(
                            position: .secondBase,
                            player: viewModel.gameState.fieldPlayers.first(where: { $0.position == .secondBase }),
                            onDrop: { player in
                                viewModel.assignPlayerToField(player, position: .secondBase)
                            }
                        )
                        
                        FieldPositionView(
                            position: .firstBase,
                            player: viewModel.gameState.fieldPlayers.first(where: { $0.position == .firstBase }),
                            onDrop: { player in
                                viewModel.assignPlayerToField(player, position: .firstBase)
                            }
                        )
                    }
                    
                    // Outfielders
                    HStack(spacing: 40) {
                        FieldPositionView(
                            position: .leftField,
                            player: viewModel.gameState.fieldPlayers.first(where: { $0.position == .leftField }),
                            onDrop: { player in
                                viewModel.assignPlayerToField(player, position: .leftField)
                            }
                        )
                        
                        FieldPositionView(
                            position: .centerField,
                            player: viewModel.gameState.fieldPlayers.first(where: { $0.position == .centerField }),
                            onDrop: { player in
                                viewModel.assignPlayerToField(player, position: .centerField)
                            }
                        )
                        
                        FieldPositionView(
                            position: .rightField,
                            player: viewModel.gameState.fieldPlayers.first(where: { $0.position == .rightField }),
                            onDrop: { player in
                                viewModel.assignPlayerToField(player, position: .rightField)
                            }
                        )
                    }
                }
                .padding()
            }
        }
    }
}

struct FieldPositionView: View {
    let position: FieldPosition
    let player: Player?
    let onDrop: (Player) -> Void
    
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
        .onDrop(of: [.utf8PlainText], isTargeted: { _ in true }) { providers in
            if let provider = providers.first {
                provider.loadDataRepresentation(forTypeIdentifier: "public.utf8-plain-text") { data, _ in
                    // Handle drop - in a real app, you'd deserialize the player ID
                }
            }
            return false
        }
    }
}

struct FieldView_Previews: PreviewProvider {
    static var previews: some View {
        FieldView(viewModel: GameViewModel())
    }
}
