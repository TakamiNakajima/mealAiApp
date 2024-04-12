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
        if authViewModel.currentUser != nil {
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
                        
                        Spacer()
                    }
                    .onAppear {
                        let monday = Calendar(identifier: .japanese).initialDayOfWeek()
                        Task {
                            // 今日の歩数更新
                            try await topPageViewModel.updateSteps(uid: authViewModel.currentUser!.id, startDate: Calendar.current.startOfDay(for: Date()), endDate: Date(), collection: Collection.dailySteps)
                            // 今週の歩数更新
                            try await topPageViewModel.updateSteps(uid:authViewModel.currentUser!.id, startDate: monday, endDate: Date(), collection: Collection.weeklySteps)
                            // ユーザリスト取得
                            try await topPageViewModel.fetchUsers(startDate: monday)
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
