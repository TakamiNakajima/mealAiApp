
import SwiftUI

struct HomePage: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject var manager: StepRepository
    
    var body: some View {
        if let user = authViewModel.currentUser {
            VStack(spacing: 0) {
                
                Text("2024年9月")
                    .font(.headline)
                    .fontWeight(.light)
                    .foregroundColor(Color.blue)
                
                Spacer()
                    .frame(height: 8)
                
                HStack {
                    DashedCircleText(number: "23")
                    DashedCircleText(number: "24")
                    DashedCircleText(number: "25")
                    DashedCircleText(number: "26")
                    DashedCircleText(number: "27")
                    DashedCircleText(number: "28")
                    CircleText(number: "29")
                }
                
                Spacer()
                    .frame(height: 8)
                
                HStack(spacing: 24) {
                    HomeConteiner(title: "歩数", value: "\(manager.stepCount)歩")
                        .onAppear {
                            Task {
                                await manager.fetchTodaySteps(uid: authViewModel.currentUser!.id)
                            }
                        }
                    HomeConteiner(title: "消費カロリー", value: "300kcal")
                }
                .padding()
            }
        }
    }
}

struct HomeConteiner: View {
    var title: String
    var value: String
    
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
                Spacer()
                HStack {
                    Spacer()
                    Text(value)
                        .font(.title)
                        .padding(5)
                        .foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
                        .fontWeight(.bold)
                }
            }
            .frame(width: 160, height: 100)
        }
    }
}
