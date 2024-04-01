//
//  ProfileView.swift
//  NoName
//
//  Created by 中島昂海 on 2024/03/24.
//

import SwiftUI
import HealthKit

struct ProfileView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    @EnvironmentObject var manager: HealthManager
    var body: some View {
        if let user = viewModel.currentUser {
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
                Section("General") {
                    HStack {
                        SettingsRowView(
                            imageName: "gear",
                            title: "Version",
                            tintColor: Color(.systemGray)
                        )
                        Spacer()
                        Text("1.0.0")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                }
                Section("Account") {
                    Button {
                        viewModel.signOut()
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
                Section("Steps") {
                    HStack {
                        Text(manager.stepCount)
                        Spacer()
                        Button {
                            manager.fetchTodaySteps()
                        } label: {
                            Image(systemName: "arrow.clockwise")
                        }
                    }
                }
        
            }
            .onAppear {
                manager.fetchTodaySteps()
            }
        }
    }
}

#Preview {
    ProfileView()
}
