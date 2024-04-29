import SwiftUI
import Firebase

@main
struct NoNameApp: App {
    @StateObject var authViewModel = AuthViewModel()
    @StateObject var topPageViewModel = TopPageViewModel()
    @StateObject var userSearchViewModel = SearchUserViewModel()
    @StateObject var profileEditPageViewModel = ProfileEditPageViewModel()
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(authViewModel)
                .environmentObject(topPageViewModel)
                .environmentObject(userSearchViewModel)
                .environmentObject(profileEditPageViewModel)
        }
    }
}
