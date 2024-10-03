
import SwiftUI

struct HomePage: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject var manager: StepRepository
    
    var body: some View {
        if let user = authViewModel.currentUser {
            VStack(spacing: 0) {
                
                Text("2024年9月")
                    .font(.headline)
                    .fontWeight(.light)
                    .foregroundColor(Color.blue)
                
                Spacer()
                    .frame(height: 8)

                HStack {
                    DashedCircleText(number: "23")
                    DashedCircleText(number: "24")
                    DashedCircleText(number: "25")
                    DashedCircleText(number: "26")
                    DashedCircleText(number: "27")
                    DashedCircleText(number: "28")
                    CircleText(number: "29")
                }
                
                Spacer()
                    .frame(height: 8)
                
//                Text("9月29日")
//                    .font(.system(size: 16))
//                    .fontWeight(.semibold)
//                    .foregroundColor(.white)
//                    .frame(maxWidth: .infinity, minHeight: 26)
//                    .background(Color.blue)
//                    .multilineTextAlignment(.center)
                
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
