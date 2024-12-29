import SwiftUI

struct BaseView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    
    var body: some View {
        Group {
            if authViewModel.userSession != nil {
                AppPage()
            } else {
                LoginPage()
            }
        }
    }
}
