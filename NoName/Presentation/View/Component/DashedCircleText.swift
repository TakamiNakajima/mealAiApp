import SwiftUI

struct DashedCircleText: View {
    let number: String
    var onTap: () -> Void
    let todayDate: String = String(Calendar.current.component(.day, from: Date()))
    
    var body: some View {
        Text(number == todayDate ? "今日" : number)
            .font(.caption)
            .fontWeight(.semibold)
            .foregroundColor(.gray)
            .frame(width: 34, height: 34)
            .background(Color(.white))
            .clipShape(Circle())
            .padding(.horizontal, 4)
            .overlay(
                Circle()
                    .stroke(style: StrokeStyle(lineWidth: 1, dash: [5]))
                    .foregroundColor(.gray)
            )
            .onTapGesture {
                onTap()
            }
    }
}
