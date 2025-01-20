
import SwiftUI

struct HomePage: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    let generator = UIImpactFeedbackGenerator(style: .light)
    @State private var isPresented: Bool = false
    
    var body: some View {
        VStack {
            Spacer()
            Button {
                generator.impactOccurred()
                isPresented = true
            } label: {
                ZStack(alignment: .center) {
                    Circle()
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    Color("mainColorLight"),
                                    Color("mainColorDark"),
                                ]),
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        .frame(width: 120, height: 120)
                    Text("献立を\n作成する")
                        .foregroundColor(Color.white)
                        .multilineTextAlignment(.center)
                }
                
                
            }
            .buttonStyle(PlainButtonStyle())
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .fullScreenCover(isPresented: $isPresented) {
            GenerateMenuPage(isPresented: $isPresented)
        }
    }
}
