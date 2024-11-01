import SwiftUI

struct PrimaryButton: View {
    var title: String
    var width: Double
    var height: Double
    let action: () -> Void

    var body: some View {
        Button(action: {
            action()
        }) {
            Text(title)
                .font(.headline)
                .frame(width: width, height: height)
                .foregroundColor(.white)
                .background(LinearGradient(
                    gradient: Gradient(colors: [.mint, .blue]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                ))
        
                .cornerRadius(20)
        }
    }
}
