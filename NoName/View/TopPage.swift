//
//  ProfileView.swift
//  NoName
//
//  Created by 中島昂海 on 2024/03/24.
//

import SwiftUI
import HealthKit

struct TopPage: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject var topPageViewModel: TopPageViewModel
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
                Section("アカウント") {
                    Button {
                        authViewModel.signOut()
                    } label: {
                        SettingsRow(
                            imageName: "arrow.left.circle.fill",
                            title: "Sign Out",
                            tintColor: Color(.red)
                        )
                    }
                }
                Section("今日の歩数  (\(topPageViewModel.stepData.timeStamp.displayDateString())更新)") {
                    HStack {
                        Text(topPageViewModel.stepData.step.formattedString())
                            .font(.system(size: 16))
                        Spacer()
                        Button(action: {
                            Task {
                                try await topPageViewModel.fetchAndSaveSteps(uid: authViewModel.currentUser!.id)
                            }
                        }) {
                            Image(systemName: "arrow.clockwise")
                        }
                        .disabled(!topPageViewModel.isButtonEnabled)
                    }
                }
                .onAppear {
                    Task {
                        try await topPageViewModel.fetchAndSaveSteps(uid: authViewModel.currentUser!.id)
                    }
                }
            }
        }
    }
}

#Preview {
    TopPage()
}
