import SwiftUI
import HealthKit

struct BaseView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @State var selectedTab:BottomBarSelectedTab = .home
    
    var body: some View {
        VStack {
            if (selectedTab == .home)  {
                HomePage(selectedTab: $selectedTab)
            } else if (selectedTab == .calendar) {
                VideoPage()
            } else if (selectedTab == .add) {
                AddPage(selectedTab: $selectedTab)
            } else if (selectedTab == .report) {
                NotificationPage()
            } else if (selectedTab == .message) {
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
