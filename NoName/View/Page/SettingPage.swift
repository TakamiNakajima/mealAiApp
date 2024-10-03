
import SwiftUI

struct SettingPage: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject var manager: StepRepository
    @State private var selectedTab: Int = 0
    @State private var canSwipe: Bool = true
    
    var body: some View {
        VStack {
            Spacer()
            Text("SettingPage")
                .multilineTextAlignment(.center)
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
