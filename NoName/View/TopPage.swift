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
                    VStack(alignment: .leading) {
                        
                        Spacer()
                            .frame(height: 40)
                        
                        Text("Weekly")
                            .foregroundColor(Color.customThemeColor)
                            .font(.title)
                            .fontWeight(.bold)
                            .padding(.leading, 20)
                        
                        VStack {
                            ForEach(topPageViewModel.users.indices, id: \.self) { index in
                                Card(user: topPageViewModel.users[index], ranking: index + 1)
                            }
                        }
                        
                        Spacer()
                        
                        //                        NavigationLink(destination: SearchUserPage()) {
                        //                            Text("ユーザ検索画面")
                        //                                .foregroundColor(Color.customThemeColor)
                        //                        }
                        
                        Spacer()
                    }
                    .onAppear {
                        let thisMonday = Date().initialDayOfWeek()
                        Task {
                            // 今日の歩数更新
                            try await topPageViewModel.updateSteps(uid: authViewModel.currentUser!.id, startDate: Calendar.current.startOfDay(for: Date()), endDate: Date(), collection: Collection.dailySteps)
                        }
                        Task {
                            // 今週の歩数更新
                            try await topPageViewModel.updateSteps(uid:authViewModel.currentUser!.id, startDate: thisMonday, endDate: Date(), collection: Collection.weeklySteps)
                        }
                        Task {
                            // ユーザリスト取得
                            try await topPageViewModel.fetchAllUsers(startDate: thisMonday)
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
