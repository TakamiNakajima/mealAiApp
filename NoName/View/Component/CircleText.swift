import SwiftUI

struct CircleText: View {
    let number: String
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 30)
                .frame(width: 36, height: 36)
                .foregroundStyle(
                    LinearGradient(
                        gradient: Gradient(colors: [.mint, .blue]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
            Text(number)
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundColor(.white)
        }
    }
}
