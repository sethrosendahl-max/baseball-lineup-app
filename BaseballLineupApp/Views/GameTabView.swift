import SwiftUI

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

struct GameTabView_Previews: PreviewProvider {
    static var previews: some View {
        GameTabView(viewModel: GameViewModel())
    }
}
