import SwiftUI

struct RegistrationPage: View {
    @State private var email = ""
    @State private var fullname = ""
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
                InputItem(
                    text: $email,
                    title: "Email Adress",
                    placeholder: "name@example.com"
                )
                .autocapitalization(.none)
                
                InputItem(
                    text: $fullname,
                    title: "fullname",
                    placeholder: "Enter your name"
                )
                
                InputItem(
                    text: $password,
                    title: "Password",
                    placeholder: "Enter your password",
                    isSecureField: true
                )
                
                ZStack(alignment: .trailing) {
                    InputItem(
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
                        fullname: fullname
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
