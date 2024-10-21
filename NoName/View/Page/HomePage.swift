
import SwiftUI

struct HomePage: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject var homePageViewModel: HomePageViewModel
    @EnvironmentObject var stepRepository: StepRepository
    @State private var isPickerPresented = false
    
    var body: some View {
        if let user = authViewModel.currentUser {
            ZStack {
                VStack(spacing: 20) {
                    
                    // AppBar
                    VStack {
                        Text("2024年9月")
                            .font(.headline)
                            .fontWeight(.light)
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
                            Text("総カロリー")
                                .font(.headline)
                                .fontWeight(.bold)
                                .foregroundColor(Color.gray)
                            Spacer()
                        }
                        .padding(.horizontal, 24)
                        
                        CaloriesConteiner()
                    }
                    
                    // 運動
                    VStack(spacing: 8) {
                        HStack {
                            Text("運動")
                                .font(.headline)
                                .fontWeight(.bold)
                                .foregroundColor(Color.gray)
                            Spacer()
                        }
                        .padding(.horizontal, 24)
                        
                        HStack(spacing: 24) {
                            HealthDataConteiner(title: "歩数", value: "\(homePageViewModel.stepCount.formattedString())", isStep: true)
                            HealthDataConteiner(title: "消費カロリー", value: "\(homePageViewModel.calories.formattedString())", isStep: false)
                        }
                    }
                    
                    // 食事
                    VStack(spacing: 8) {
                        HStack {
                            Text("食事")
                                .font(.headline)
                                .fontWeight(.bold)
                                .foregroundColor(Color.gray)
                            Spacer()
                        }
                        .padding(.horizontal, 24)
                        
                        HStack(spacing: 24) {
                            MealImage(type: 0, imageUrl: homePageViewModel.morningMeal?.imageURL, isPickerPresented: $isPickerPresented)
                            MealImage(type: 1, imageUrl: homePageViewModel.lunchMeal?.imageURL, isPickerPresented: $isPickerPresented)
                        }
                        
                        Spacer()
                            .frame(height: 2)
                        
                        HStack(spacing: 24) {
                            MealImage(type: 2, imageUrl: homePageViewModel.dinnerMeal?.imageURL, isPickerPresented: $isPickerPresented)
                            MealImage(type: 3, imageUrl: homePageViewModel.breakMeal?.imageURL, isPickerPresented: $isPickerPresented)
                        }
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
