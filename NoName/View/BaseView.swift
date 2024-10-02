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
                VideoPage()
            } else if (selectedTab == .add) {
                AddPage()
            } else if (selectedTab == .notification) {
                NotificationPage()
            } else if (selectedTab == .message) {
                SettingPage()
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
        if let user = authViewModel.currentUser {
            VStack(spacing: 0) {
                
                Text("ホーム")
                    .font(.headline)
                    .foregroundColor(.black)
                    .frame(height: 48)
                    .padding(.horizontal)
                    .background(.white)
                    .foregroundColor(.black)
                
                Text("9月29日")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, minHeight: 28)
                    .background(Color.blue)
                    .multilineTextAlignment(.center)
                
                List {
                    
                    Section("カロリー") {
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
                    Section("運動") {
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
                    Section("食事") {
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
}

struct VideoPage: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject var manager: StepRepository
    
    var body: some View {
        VStack {
            Spacer()
            Text("VideoPage")
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
