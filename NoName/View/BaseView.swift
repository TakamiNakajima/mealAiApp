import SwiftUI
import HealthKit

struct BaseView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject var manager: StepRepository
    @State var selectedTab:BottomBarSelectedTab = .home
    
    var body: some View {
        VStack {
            if (selectedTab == .home)  {
                HomePage(selectedTab: $selectedTab)
            } else if (selectedTab == .workout) {
                VideoPage()
            } else if (selectedTab == .add) {
                AddPage(selectedTab: $selectedTab)
            } else if (selectedTab == .notification) {
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
