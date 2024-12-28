import SwiftUI

struct GenerateMenuPage: View {
    @Binding var isPresented: Bool
    let generator = UIImpactFeedbackGenerator(style: .light)
    
    var body: some View {
        Button {
            generator.impactOccurred()
            isPresented = false
        } label: {
            Text("戻る")
        }
    }
}
