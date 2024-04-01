//
//  ProfileView.swift
//  NoName
//
//  Created by 中島昂海 on 2024/03/24.
//

import SwiftUI
import HealthKit

struct ProfileView: View {
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

#Preview {
    ProfileView()
}
