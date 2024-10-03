import SwiftUI

struct CircleText: View {
    let number: String

    var body: some View {
        Text(number)
            .font(.caption)
            .fontWeight(.semibold)
            .foregroundColor(.white)
            .frame(width: 36, height: 36)
            .background(Color.blue)
            .clipShape(Circle())
            .padding(.horizontal, 4)
    }
}
