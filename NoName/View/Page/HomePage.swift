
import SwiftUI

struct HomePage: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject var homePageViewModel: HomePageViewModel
    @EnvironmentObject var stepRepository: StepRepository
    @State private var isPickerPresented = false
    @Binding var selectedTab:BottomBarSelectedTab

    var body: some View {
        if let _ = authViewModel.currentUser {
            ZStack {
                VStack(spacing: 20) {
                    
                    // AppBar
                    VStack {
                        Text("2024年9月")
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundColor(Color.blue)
                        
                        ScrollViewReader { proxy in
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack {
                                    ForEach(homePageViewModel.thisMonthDays, id: \.self) { day in
                                        if day == homePageViewModel.selectedDate {
                                            CircleText(number: day)
                                        } else {
                                            DashedCircleText(number: day) {
                                                homePageViewModel.onTapCircle(day: day)
                                                withAnimation {
                                                    proxy.scrollTo(day, anchor: .center)
                                                }
                                            }
                                        }
                                    }
                                }
                                .padding()
                            }
                            .onAppear {
                                let todayDate = homePageViewModel.getTodayDate()
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1)  {
                                    proxy.scrollTo(todayDate, anchor: .center)
                                }
                            }
                        }
                    }
                    
                    // 総カロリー表示
                    VStack(spacing: 8) {
                        HStack {
                            Text("トータル")
                                .font(.headline)
                                .fontWeight(.bold)
                                .foregroundColor(Color.gray)
                            Spacer()
                        }
                        .padding(.horizontal, 24)
                        
                        CaloriesConteiner(totalKcal: homePageViewModel.totalKcal ?? 0, goalKcal: homePageViewModel.goalKcal ?? 0)
                    }
                    
                    // 支出
                    VStack(spacing: 8) {
                        HStack {
                            Text("支出")
                                .font(.headline)
                                .fontWeight(.bold)
                                .foregroundColor(Color.gray)
                            Spacer()
                        }
                        .padding(.horizontal, 24)
                    
                        RecordContainer(title: "コンビニ", value: "\(homePageViewModel.stepCount.formattedString())")

                    }
                    
                    // 収入
                    VStack(spacing: 8) {
                        HStack {
                            Text("収入")
                                .font(.headline)
                                .fontWeight(.bold)
                                .foregroundColor(Color.gray)
                            Spacer()
                        }
                        .padding(.horizontal, 24)
                        
                        RecordContainer(title: "友人からの返金", value: "\(homePageViewModel.stepCount.formattedString())")
                    }
                }
                .onAppear {
                    Task {
                        // 初期処理
                        await homePageViewModel.initialize(uid: authViewModel.currentUser!.id)
                    }
                }
            
                if homePageViewModel.isLoading {
                    ZStack {
                        Color.white.opacity(0.6)
                            .ignoresSafeArea()
                        ProgressView("Loading...")
                                            .progressViewStyle(CircularProgressViewStyle())
                                            .padding()
                    }
                    
                }
            }
        
        }
    }
}
