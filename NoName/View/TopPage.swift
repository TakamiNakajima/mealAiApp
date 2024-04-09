//
//  ProfileView.swift
//  NoName
//
//  Created by 中島昂海 on 2024/03/24.
//

import SwiftUI
import HealthKit

struct TopPage: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject var topPageViewModel: TopPageViewModel
    @EnvironmentObject var manager: StepRepository
    var body: some View {
        if let user = authViewModel.currentUser {
            NavigationView {
                ZStack {
                    // 背景色
                    VStack(spacing: 0) {
                        Color.customSubColor
                    }
                    .edgesIgnoringSafeArea(.all)
                    
                    // アカウント情報
                    VStack(alignment: .center) {
                        
                        Spacer()
                            .frame(height: 40)
                        
                        VStack {
                            ForEach(topPageViewModel.users, id: \.id) { user in
                                Card(user: user)
                            }
                        }
                        
                        Spacer()
                        
                        NavigationLink(destination: SearchUserPage()) {
                            Text("ユーザ検索画面")
                                .foregroundColor(Color.customThemeColor)
                        }
                        
                        Button {
                            authViewModel.signOut()
                        } label: {
                            SettingsRow(
                                imageName: "arrow.left.circle.fill",
                                title: "Sign Out",
                                tintColor: Color.customThemeColor
                            )
                        }
                        
                        Spacer()
                    }
                    .onAppear {
                        Task {
                            try await topPageViewModel.fetchAndSaveSteps(uid: authViewModel.currentUser!.id)
                            try await topPageViewModel.fetchUsers()
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    TopPage()
}
