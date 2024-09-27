import SwiftUI
import HealthKit

struct BaseView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject var manager: StepRepository
    @State var selectedTab:BottomBarSelectedTab = .home
    
    var body: some View {
        VStack {
            if (selectedTab == .home)  {
                HomePage()
            } else if (selectedTab == .workout) {
                WorkoutPage()
            } else if (selectedTab == .add) {
                AddPage()
            } else if (selectedTab == .notification) {
                NotificationPage()
            } else if (selectedTab == .message) {
                MessagePage()
            }
            
            Spacer()

            // ボトムナビゲーションバー
            BottomBar(selectedTab: $selectedTab)
        }
    }
}

struct HomePage: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject var manager: StepRepository
    
    var body: some View {
        VStack {
            Spacer()
            Text("HomePage")
                .multilineTextAlignment(.center)
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}


struct WorkoutPage: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject var manager: StepRepository
    
    var body: some View {
        VStack {
            Spacer()
            Text("WorkoutPage")
                .multilineTextAlignment(.center)
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct AddPage: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject var manager: StepRepository
    
    var body: some View {
        VStack {
            Spacer()
            Text("AddPage")
                .multilineTextAlignment(.center)
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct NotificationPage: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject var manager: StepRepository
    
    var body: some View {
        VStack {
            Spacer()
            Text("NotificationPage")
                .multilineTextAlignment(.center)
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct MessagePage: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject var manager: StepRepository
    
    var body: some View {
        if let user = authViewModel.currentUser {
            List {
                Section {
                    HStack {
                        Text(user.initials)
                            .font(.title)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .frame(width: 72, height: 72)
                            .background(Color(.systemGray3))
                            .clipShape(Circle())
                        VStack(alignment: .leading, spacing: 4){
                            Text(user.fullname)
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .padding(.top, 4)
                            Text(user.email)
                                .font(.footnote)
                                .foregroundColor(.gray)
                        }
                    }
                }
                Section("Steps") {
                    HStack {
                        Text(manager.stepCount)
                        Spacer()
                        Button(action: {
                            Task {
                                await manager.fetchTodaySteps(uid: authViewModel.currentUser!.id)
                            }
                        }) {
                            Image(systemName: "arrow.clockwise")
                        }
                    }
                }
                Section("Account") {
                    Button {
                        authViewModel.signOut()
                    } label: {
                        SettingsRowView(
                            imageName: "arrow.left.circle.fill",
                            title: "Sign Out",
                            tintColor: Color(.red)
                        )
                    }
                    Button {
                        print("Delete account..")
                    } label: {
                        SettingsRowView(
                            imageName: "xmark.circle.fill",
                            title: "Delete Account",
                            tintColor: Color(.red)
                        )
                    }
                }
            }
            .onAppear {
                Task {
                    await manager.fetchTodaySteps(uid: authViewModel.currentUser!.id)
                }
            }
        }
    }
}
