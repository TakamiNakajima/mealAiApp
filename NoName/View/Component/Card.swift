import SwiftUI

struct Card: View {
    var user: UserData
    var ranking: Int
    
    var body: some View {
        HStack {
            VStack {
                Spacer()
                HStack {
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
                .cornerRadius(16)
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
            return LinearGradient(gradient: Gradient(colors: [Color.customFirstColorDark, Color.customFirstColorLight]), startPoint: .topLeading, endPoint: .bottomTrailing)
        case 2:
            return LinearGradient(gradient: Gradient(colors: [Color.customSecondColorDark, Color.customSecondColorLight]), startPoint: .topLeading, endPoint: .bottomTrailing)
        case 3:
            return LinearGradient(gradient: Gradient(colors: [Color.customThirdColorDark, Color.customThirdColorLight]), startPoint: .topLeading, endPoint: .bottomTrailing)
        default:
            return LinearGradient(gradient: Gradient(colors: [Color.white, Color.white]), startPoint: .topLeading, endPoint: .bottomTrailing)
        }
        
    }
}
