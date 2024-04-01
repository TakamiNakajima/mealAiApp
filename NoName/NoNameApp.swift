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
    @StateObject var authViewModel = AuthViewModel()
    @StateObject var manager = StepRepository()
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(authViewModel)
                .environmentObject(manager)
        }
    }
}
