import SwiftUI
import HealthKit

struct TopPage: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject var topPageViewModel: TopPageViewModel
    @Environment(\.scenePhase) var scenePhase
    
    var body: some View {
        if authViewModel.currentUser != nil {
            NavigationView {
                ScrollView {
                    VStack {
                        Text(displayTime())
                            .font(.system(size: 16))
                            .fontWeight(.regular)
                            .foregroundColor(Color.customThemeColor)
                            .padding(.bottom, 8)
                        HStack {
                            HStack {
                                VStack(alignment: .leading) {
                                    Text("WIN $10!")
                                        .font(.system(size: 20))
                                        .fontWeight(.heavy)
                                        .foregroundColor(Color.customThemeColor)
                                    Spacer()
                                        .frame(height: 8)
                                    Text("Today's highest token balance wins!")
                                        .font(.system(size: 14))
                                        .fontWeight(.medium)
                                        .foregroundColor(Color.customThemeColor)
                                    Spacer()
                                        .frame(height: 2)
                                    Text("Today's highest!")
                                        .font(.system(size: 14))
                                        .fontWeight(.medium)
                                        .foregroundColor(Color.customOrange)
                                }
                                .padding(16)
                                Spacer()
                            }
                            .frame(height: 124)
                            .padding(12)
                            .background(LinearGradient(gradient: Gradient(colors: [Color.customFirstColorDark, Color.customFirstColorLight]), startPoint: .top, endPoint: .bottom))
                            .cornerRadius(16)
                            .clipped()
                            .shadow(color: .gray.opacity(0.7), radius: 5)
                            
                        }
                        .padding(.horizontal, 24)
                        .padding(.bottom, 16)
                        HStack(alignment: .bottom) {
                            Text("Ranking")
                                .font(.system(size: 24))
                                .fontWeight(.bold)
                                .foregroundColor(Color.customThemeColor)
                            Spacer()
                            Text("Weekly")
                                .font(.system(size: 14))
                                .fontWeight(.bold)
                                .foregroundColor(Color.gray)
                        }
                        .padding(.horizontal, 24)
                        .padding(.top, 4)
                        ForEach(topPageViewModel.users.indices, id: \.self) { index in
                            Card(user: topPageViewModel.users[index], ranking: index + 1)
                        }
                        Button {
                            Task {
                                try await authViewModel.signOut()
                            }
                        } label: {
                            Text("ログアウト")
                        }
                        Spacer()
                    }
                }
                .toolbar {
                    NavigationLink(destination: SearchUserPage()) {
                        Image(systemName: "person.badge.plus")
                            .foregroundColor(Color.customThemeColor)
                    }
                }
            }
            .onAppear {
                fetchData()
                topPageViewModel.countdownTimer()
            }
            .onChange(of: scenePhase) {
                if scenePhase == .active {
                    fetchData()
                }
            }
        }
    }
    
    func displayTime() -> String {
        let remainingDays = Int(topPageViewModel.remaining / (3600 * 24))
        let remainingHours = Int((topPageViewModel.remaining.truncatingRemainder(dividingBy: (3600 * 24))) / 3600)
        let remainingMinutes = Int((topPageViewModel.remaining.truncatingRemainder(dividingBy: 3600)) / 60)
        let remainingSeconds = Int(topPageViewModel.remaining.truncatingRemainder(dividingBy: 60))
        
        return  "残り\(remainingDays)日 \(remainingHours)時間\(remainingMinutes)分\(remainingSeconds)秒"
    }
    
    func fetchData() {
        DispatchQueue.global().async {
            Task {
                let thisMonday = Date().initialDayOfWeek()
                // 今日の歩数更新
                try await topPageViewModel.updateSteps(uid: authViewModel.currentUser!.id, startDate: Calendar.current.startOfDay(for: Date()), endDate: Date(), collection: Collection.dailySteps)
                // 今週の歩数更新
                try await topPageViewModel.updateSteps(uid:authViewModel.currentUser!.id, startDate: thisMonday, endDate: Date(), collection: Collection.weeklySteps)
                // ユーザリスト取得
                try await topPageViewModel.fetchAllUsers(startDate: thisMonday)
            }
        }
    }
}

#Preview {
    TopPage()
}
