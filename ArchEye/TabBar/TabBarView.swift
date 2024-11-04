import SwiftUI

struct TabBarView: View {
    
    @State var tab = 1
    @StateObject private var viewModel = ViewModel()
    
    var body: some View {
        ZStack(alignment: .bottom) {
            tabs

            selectedTab
        }
    }
}

extension TabBarView {
    
    var tabs: some View {
        TabView(selection: $tab) {
            HistoryView(viewModel: viewModel).tag(0)
            
            ExploreView(viewModel: viewModel).tag(1)
            
            ProfileView().tag(2)
        }
        
    }
    
    var selectedTab: some View {
        ZStack {
            HStack {
                ForEach(TabItems.allCases, id: \.self) { item in
                    Button(
                        action: { tab = item.rawValue },
                        label: { TabItem(imageName: item.icon, title: item.title, isActive: (tab == item.rawValue)) }
                    )
                }
            }
            .padding(6)
        }
        .background(.clear)
        .frame(height: 70)
        .cornerRadius(35)
        .padding(.horizontal, 26)
    }
}
