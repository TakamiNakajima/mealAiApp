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
            VStack() {
                ZStack(alignment: .bottomLeading) {
                    Color(Color(red: 70/255, green: 158/255, blue: 208/255))
                        .ignoresSafeArea()
                    ZStack(alignment: .leading) {
                        Rectangle()
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .shadow(radius: 5)
                        HStack {
                            Text(user.initials)
                                .font(.title)
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                                .frame(width: 64, height: 64)
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
                            Spacer()
                            VStack {
                                Text(topPageViewModel.stepData.step.formattedString())
                                    .font(.system(size: 24))
                                    .fontWeight(.bold)

                                Text("(\(topPageViewModel.stepData.timeStamp.displayDateString())更新)")
                                    .font(.system(size: 12))
                                    .foregroundColor(.gray)
                                    .fontWeight(.light)
                            }
                            Button(action: {
                                Task {
                                    try await topPageViewModel.fetchAndSaveSteps(uid: authViewModel.currentUser!.id)
                                }
                            }) {
                                Image(systemName: "arrow.clockwise")
                            }
                            .disabled(!topPageViewModel.isButtonEnabled)
                        }
                        .padding()
                    }
                    .offset(x: 0, y: 32)
                    .padding(.horizontal, 24)
                    .onAppear {
                        Task {
                            try await topPageViewModel.fetchAndSaveSteps(uid: authViewModel.currentUser!.id)
                        }
                    }
                }
                .frame(height: 96)
                Spacer()
//                Section("アカウント") {
//                    Button {
//                        authViewModel.signOut()
//                    } label: {
//                        SettingsRow(
//                            imageName: "arrow.left.circle.fill",
//                            title: "Sign Out",
//                            tintColor: Color(.red)
//                        )
//                    }
//                }
            }
        }
    }
}

#Preview {
    TopPage()
}
