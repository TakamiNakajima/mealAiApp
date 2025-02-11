import SwiftUI
import HealthKit

struct AppView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @State var selectedTab:BottomBarSelectedTab = .home
    
    var body: some View {
        VStack {
            if (selectedTab == .home)  {
                HomePage()
            } else if (selectedTab == .calendar) {
                CalendarPage()
            } else if (selectedTab == .add) {
                AddPage(selectedTab: $selectedTab)
            } else if (selectedTab == .report) {
                ReportPage()
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
    func makeUIViewController(context: Context) -> UINavigationController {
        let firstVC = SettingPage()
        let navigationController = UINavigationController(rootViewController: firstVC)
        return navigationController
    }

    func updateUIViewController(_ uiViewController: UINavigationController, context: Context) {
        // 必要な更新ロジックがあればここに記述
    }
}
