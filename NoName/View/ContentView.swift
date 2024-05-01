import SwiftUI

struct ContentView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    
    var body: some View {
        Group {
             if (viewModel.userSession != nil) {
                TopView()
            } else {
                LoginView()
            }
        }
    }
}

#Preview {
    ContentView()
}
