import SwiftUI
import HealthKit

struct AppPage: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @State var selectedTab:BottomBarSelectedTab = .home
    
    var body: some View {
        VStack {
            if (selectedTab == .home)  {
                HomePage()
            } else if (selectedTab == .shopping) {
                ShoppingPage()
            } else if (selectedTab == .add) {
                AddPage(selectedTab: $selectedTab)
            } else if (selectedTab == .menu) {
                MenuListPage(selectedTab: $selectedTab)
            } else if (selectedTab == .setting) {
                UIKitSettingView()
            }
            
            Spacer()
            
            // ボトムナビゲーションバー
            BottomBar(selectedTab: $selectedTab)
        }
    }
}

// SettingPage(UIKit)
struct UIKitSettingView: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> SettingViewController {
        return SettingViewController()
    }
    
    func updateUIViewController(_ uiViewController: SettingViewController, context: Context) {
        // 必要な更新ロジックがあればここに記述
    }
}
