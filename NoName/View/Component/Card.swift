import SwiftUI

struct Card: View {
    var user: UserData
    var ranking: Int
    
    var body: some View {
        HStack {
            VStack {
                Spacer()
                HStack {
                    
                    ZStack(alignment: .topLeading) {
                        
                        // 画像
                        AsyncImage(url: URL(string: user.imageUrl)) { image in
                            image
                                .resizable()
                                .clipShape(Circle())
                        } placeholder: {
                            ProgressView()
                        }
                        .frame(width: 44, height: 44)
                        .foregroundColor(Color.customSubColor)
                        
                        ZStack {
                            
                            Circle()
                                .frame(width: 16, height: 16)
                                .foregroundColor(Color.customOrange)
                            
                            Text(String(ranking))
                                .foregroundColor(Color.white)
                                .font(.system(size: 14))
                                .fontWeight(.bold)
                            
                        }
                        
                    }
                    
                    Spacer()
                        .frame(width: 8)
                    
                    VStack(alignment: .leading) {
                        Text(user.fullname)
                            .font(.system(size: 14))
                            .fontWeight(.bold)
                            .foregroundColor(Color.customThemeColor)
                        
                        Text(("@\(user.accountName)"))
                            .font(.system(size: 11))
                            .fontWeight(.light)
                            .foregroundColor(Color.customThemeColor)
                    }
                    
                    Spacer()
                    
                    VStack() {
                        HStack(alignment: .bottom) {
                            Spacer()
                            Text(user.weeklyStepData?.step.formatString() ?? "--")
                                .font(.system(size: 22))
                                .foregroundColor(Color.customThemeColor)
                                .fontWeight(.bold)
                        }
                        HStack {
                            Spacer()
                            if (user.weeklyStepData != nil) {
                                Text("(\(user.weeklyStepData!.timeStamp.displayDateString()))")
                                    .font(.system(size: 9))
                                    .fontWeight(.regular)
                                    .foregroundColor(Color.customThemeColor)
                            }
                        }
                    }
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 16)
                .background(rankColor(rank: ranking))
                .cornerRadius(8)
                .clipped()
                .shadow(color: .gray.opacity(0.7), radius: 5)
            }
            .frame(height: 80)
        }
        .padding(.horizontal, 24)
    }
    
    func rankColor(rank: Int) -> LinearGradient {
        switch rank {
        case 1:
            return LinearGradient(gradient: Gradient(colors: [Color.customFirstColorDark, Color.customFirstColorLight]), startPoint: .top, endPoint: .bottom)
        case 2:
            return LinearGradient(gradient: Gradient(colors: [Color.customSecondColorDark, Color.customSecondColorLight]), startPoint: .top, endPoint: .bottom)
        case 3:
            return LinearGradient(gradient: Gradient(colors: [Color.customThirdColorDark, Color.customThirdColorLight]), startPoint: .top, endPoint: .bottom)
        default:
            return LinearGradient(gradient: Gradient(colors: [Color.customSubColor, Color.customSubColor]), startPoint: .top, endPoint: .bottom)
        }
        
    }
}
