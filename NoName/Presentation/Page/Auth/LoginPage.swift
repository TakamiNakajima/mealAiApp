import SwiftUI
import _SwiftData_SwiftUI

struct LoginPage: View {
    @Environment(\.modelContext) private var context
    @State private var email = ""
    @State private var password = ""
    @EnvironmentObject var viewModel: AuthViewModel
    
    var body: some View {
        NavigationStack {
            VStack {
                
                // image
                Image("mealaiicon")
                    .resizable()
                    .scaledToFill()
                    .frame(width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, height: 120)
                    .padding(.vertical, 32)
                
                // form fields
                VStack(spacing: 24) {
                    
                    InputItem(
                        text: $email,
                        title: "Email Adress",
                        placeholder: "name@example.com"
                    )
                    .autocapitalization(.none)
                    
                    InputItem(
                        text: $password,
                        title: "Password",
                        placeholder: "Enter your password",
                        isSecureField: true
                    )
                    
                }
                .padding(.horizontal)
                .padding(.top, 12)
                // ログイン処理
                Button {
                    Task {
                        try await viewModel.signIn(withEmail: email, password: password)
                        saveCredentials(email: email, password: password)
                    }
                } label: {
                    
                    HStack {
                        
                        Text("SIGN IN")
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
                
                // sign up button
                NavigationLink {
                    RegistrationPage()
                        .navigationBarBackButtonHidden(true)
                } label: {
                    
                    HStack(spacing: 3) {
                        
                        Text("Don't have an account?")
                        
                        Text("Sign up")
                            .fontWeight(.bold)
                        
                    }
                    .font(.system(size: 14))
                    
                }
                
                
            }
            .onAppear {
                let savedCredentials = fetchCredentials()
                if let firstCredential = savedCredentials.first {
                    email = firstCredential.email
                    password = firstCredential.password
                }
            }
        }
    }
    
    private func saveCredentials(email: String, password: String) {
        let userCredentials = UserCredentials(email: email, password: password)
        
        do {
            try context.insert(userCredentials)
            try context.save()
            print("保存に成功しました")
        } catch {
            print("保存に失敗しました: \(error.localizedDescription)")
        }
    }
    
    private func fetchCredentials() -> [UserCredentials] {
        do {
            let credentials = try context.fetch(FetchDescriptor<UserCredentials>())
            return credentials
        } catch {
            print("データ取得に失敗しました: \(error.localizedDescription)")
            return []
        }
    }
}

extension LoginPage: AuthentiationFormProtocol {
    var formIsValid: Bool {
        return !email.isEmpty
        && email.contains("@")
        && !password.isEmpty
        && password.count > 5
    }
}
