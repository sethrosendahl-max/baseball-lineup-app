import SwiftUI

struct ScoreboardView: View {
    @ObservedObject var viewModel: GameViewModel
    @State private var homeTeamName = ""
    @State private var awayTeamName = ""
    @State private var isEditingTeamNames = false
    
    var body: some View {
        VStack(spacing: 16) {
            // Team Names
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
            
            // Score Display
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
            
            // Inning Info
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

struct ScoreboardView_Previews: PreviewProvider {
    static var previews: some View {
        ScoreboardView(viewModel: GameViewModel())
    }
}
