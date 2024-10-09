
import SwiftUI

struct HomePage: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject var manager: StepRepository
    
    var body: some View {
        if let user = authViewModel.currentUser {
            VStack(spacing: 24) {
                
                // AppBar
                VStack {
                    Text("2024年9月")
                        .font(.headline)
                        .fontWeight(.light)
                        .foregroundColor(Color.blue)
                    
                    HStack {
                        DashedCircleText(number: "23")
                        DashedCircleText(number: "24")
                        DashedCircleText(number: "25")
                        DashedCircleText(number: "26")
                        DashedCircleText(number: "27")
                        DashedCircleText(number: "28")
                        CircleText(number: "29")
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
                        HealthDataConteiner(title: "歩数", value: "\(manager.stepCount)", isStep: true)
                            .onAppear {
                                Task {
                                    await manager.fetchTodaySteps(uid: authViewModel.currentUser!.id)
                                }
                            }
                        HealthDataConteiner(title: "消費カロリー", value: "300", isStep: false)
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
                
                HStack(alignment: VerticalAlignment.bottom, spacing: 0){
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
