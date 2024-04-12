//
//  NoNameApp.swift
//  NoName
//
//  Created by 中島昂海 on 2024/03/22.
//

import SwiftUI
import Firebase

@main
struct NoNameApp: App {
    @StateObject var stepRepository = StepRepository()
    @StateObject var userRepository = UserRepository()
    @StateObject var authViewModel = AuthViewModel()
    @StateObject var topPageViewModel = TopPageViewModel()
    @StateObject var userSearchViewModel = SearchUserViewModel()
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(stepRepository)
                .environmentObject(userRepository)
                .environmentObject(authViewModel)
                .environmentObject(topPageViewModel)
                .environmentObject(userSearchViewModel)
        }
    }
}
