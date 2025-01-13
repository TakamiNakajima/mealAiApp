import SwiftUI
import Firebase

private struct SafeAreaInsetsEnvironmentKey: EnvironmentKey {
    static let defaultValue: (top: CGFloat, bottom: CGFloat) = (0, 0)
}

extension EnvironmentValues {
    var safeAreaInsets: (top: CGFloat, bottom: CGFloat) {
        get { self[SafeAreaInsetsEnvironmentKey.self] }
        set { self[SafeAreaInsetsEnvironmentKey.self] = newValue }
    }
}

@main
struct NoNameApp: App {
    @StateObject var authViewModel = AuthViewModel()
    @StateObject var menuPageViewModel = MenuListPageViewModel()
    @StateObject var addPageViewModel = AddPageViewModel()
    @StateObject var shoppingPageViewModel = ShoppingPageViewModel()
    @StateObject var generateMenuPageViewModel = GenerateMenuViewModel()
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            BaseView()
                .environmentObject(authViewModel)
                .environmentObject(menuPageViewModel)
                .environmentObject(addPageViewModel)
                .environmentObject(shoppingPageViewModel)
                .environmentObject(generateMenuPageViewModel)
        }
    }
}
