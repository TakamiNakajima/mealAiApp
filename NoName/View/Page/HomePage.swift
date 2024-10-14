
import SwiftUI

struct HomePage: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject var homePageViewModel: HomePageViewModel
    @EnvironmentObject var stepRepository: StepRepository
    
    var body: some View {
        if let user = authViewModel.currentUser {
            VStack(spacing: 24) {
                
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
                CaloriesConteiner()
                
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
                        MealDataConteiner(title: "朝")
                        MealDataConteiner(title: "昼")
                    }
                    
                    Spacer()
                        .frame(height: 2)
                    
                    HStack(spacing: 24) {
                        MealDataConteiner(title: "夜")
                        MealDataConteiner(title: "間食")
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

struct CaloriesConteiner: View {
    var body: some View {
        
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color(UIColor.systemGray6))
                .frame(height: 120)
        }
        .padding(.horizontal, 24)
    }
}

struct HealthDataConteiner: View {
    var title: String
    var value: String
    var isStep: Bool
    var body: some View {
        ZStack {
            
            RoundedRectangle(cornerRadius: 10)
                .fill(Color(UIColor.systemGray6))
                .frame(width: 160, height: 100)
            
            VStack {
                HStack {
                    Text(title)
                        .font(.subheadline)
                        .padding(5)
                        .foregroundColor(.gray)
                    
                    Spacer()
                }
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                
                Spacer()
                
                HStack(alignment: VerticalAlignment.bottom, spacing: 2){
                    Spacer()
                    
                    Text(value)
                        .font(.title)
                        .foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
                        .fontWeight(.bold)
                    
                    Text((isStep) ? "歩" : "kcal")
                        .font(.headline)
                        .foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
                        .fontWeight(.bold)
                        .padding(.bottom, 2)
                    
                }
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                
            }
            .frame(width: 160, height: 100)
            
        }
    }
}

struct MealDataConteiner: View {
    var title: String
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.white)
                .frame(width: 160, height: 100)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .strokeBorder(style: StrokeStyle(lineWidth: 1, dash: [5]))
                        .foregroundColor(.gray)
                )
            
            Text(title)
                .font(.subheadline)
                .padding(5)
                .foregroundColor(.gray)
        }
    }
}
