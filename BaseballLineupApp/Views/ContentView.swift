import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = GameViewModel()
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            // Game View
            GameTabView(viewModel: viewModel)
                .tabItem {
                    Label("Game", systemImage: "baseball")
                }
                .tag(0)
            
            // Lineup View
            LineupTabView(viewModel: viewModel)
                .tabItem {
                    Label("Lineup", systemImage: "list.number")
                }
                .tag(1)
            
            // Field View
            FieldTabView(viewModel: viewModel)
                .tabItem {
                    Label("Field", systemImage: "square.grid.2x2")
                }
                .tag(2)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
