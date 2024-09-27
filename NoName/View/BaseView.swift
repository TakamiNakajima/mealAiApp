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
    @State private var selectedTab: Int = 0
    @State private var canSwipe: Bool = true
    
    let list: [String] = ["ホーム", "体重", "食事", "運動", "その他"]
    
    var body: some View {
        VStack {
            Spacer()
                .frame(height: 40)
            TopTabView(list: list, selectedTab: $selectedTab)
            TabView(selection: $selectedTab,
                    content: {
                Text("ホームタブ")
                    .tag(0)
                Text("体重タブ")
                    .tag(1)
                Text("食事タブ")
                    .tag(2)
                Text("運動タブ")
                    .tag(3)
                Text("その他タブ")
                    .tag(4)
            })
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            .disabled(!canSwipe)
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
