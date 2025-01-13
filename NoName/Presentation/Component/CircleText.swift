import SwiftUI

struct CircleText: View {
    let number: String
    let todayDate: String = String(Calendar.current.component(.day, from: Date()))

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 30)
                .frame(width: 38, height: 38)
                .foregroundStyle(
                    LinearGradient(
                        gradient: Gradient(colors: [.mint, .blue]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
            Text(number == todayDate ? "今日" : number)
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundColor(.white)
        }
    }
}
