
import SwiftUI

struct HomePage: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject var homePageViewModel: HomePageViewModel
    @EnvironmentObject var stepRepository: StepRepository
    @State private var morningImage: UIImage? = nil
    @State private var lunchImage: UIImage? = nil
    @State private var dinnerImage: UIImage? = nil
    @State private var breakImage: UIImage? = nil
    @State private var isPickerPresented = false
    
    var body: some View {
        if let user = authViewModel.currentUser {
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
                        MealImage(title: "朝", morningImage: $morningImage, isPickerPresented: $isPickerPresented)
                        MealImage(title: "昼", morningImage: $lunchImage, isPickerPresented: $isPickerPresented)
                    }
                    
                    Spacer()
                        .frame(height: 2)
                    
                    HStack(spacing: 24) {
                        MealImage(title: "夜", morningImage: $dinnerImage, isPickerPresented: $isPickerPresented)
                        MealImage(title: "間食", morningImage: $breakImage, isPickerPresented: $isPickerPresented)
                    }
                }
            }
            .onAppear {
                Task {
                    // 初期処理
                    await homePageViewModel.initialize(uid: authViewModel.currentUser!.id)
                }
            }
        }
    }
}
