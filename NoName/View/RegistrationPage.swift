//
//  RegistrationView.swift
//  NoName
//
//  Created by 中島昂海 on 2024/03/23.
//

import SwiftUI

struct RegistrationPage: View {
    @State private var email = ""
    @State private var fullname = ""
    @State private var accountName = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var viewModel: AuthViewModel
    
    var body: some View {
        VStack {
            // image
            Image("firebase")
                .resizable()
                .scaledToFill()
                .frame(width: 100, height: 120)
                .padding(.vertical, 32)
            VStack(spacing: 24) {
                InputField(
                    text: $email,
                    title: "Email Adress",
                    placeholder: "name@example.com"
                )
                .autocapitalization(.none)
                
                InputField(
                    text: $fullname,
                    title: "fullname",
                    placeholder: "Enter your full name"
                )
                
                InputField(
                    text: $accountName,
                    title: "accountName",
                    placeholder: "Enter your accountName"
                )
                
                InputField(
                    text: $password,
                    title: "Password",
                    placeholder: "Enter your password",
                    isSecureField: true
                )
                
                ZStack(alignment: .trailing) {
                    InputField(
                        text: $confirmPassword,
                        title: "Confirm Password",
                        placeholder: "Confirm your password",
                        isSecureField: true
                    )
                    if !password.isEmpty && !confirmPassword.isEmpty {
                        if password == confirmPassword {
                            Image(systemName: "checkmark.circle.fill")
                                .imageScale(.large)
                                .fontWeight(.bold)
                                .foregroundColor(Color(.systemGreen))
                        } else {
                            Image(systemName: "xmark.circle.fill")
                                .imageScale(.large)
                                .fontWeight(.bold)
                                .foregroundColor(Color(.systemRed))
                        }
                    }
                }
            }
            .padding(.horizontal)
            .padding(.top, 12)
            
            Button {
                Task {
                    try await viewModel.createUser(
                        withEmail: email,
                        password: password,
                        fullname: fullname,
                        accountName: accountName
                    )
                }
            } label: {
                HStack {
                    Text("SIGN UP")
                        .fontWeight(.semibold)
                    Image(systemName: "arrow.right")
                }
                .foregroundColor(.white)
                .frame(width: UIScreen.main.bounds.width - 32, height: 48)
            }
            .background(Color(.systemBlue))
            .disabled(!formIsValid)
            .opacity(formIsValid ? 1.0 : 0.5)
            .cornerRadius(10)
            .padding(.top, 24)
            
            Spacer()
            
            Button {
                dismiss()
            } label: {
                HStack(spacing: 3) {
                    Text("Already have an account?")
                    Text("Sign in")
                        .fontWeight(.bold)
                }
                .font(.system(size: 14))
            }
            
        }
    }
}

extension RegistrationPage: AuthentiationFormProtocol {
    var formIsValid: Bool {
        return !email.isEmpty
        && email.contains("@")
        && !password.isEmpty
        && password.count > 5
        && confirmPassword == password
        && !fullname.isEmpty
    }
}

#Preview {
    RegistrationPage()
}
