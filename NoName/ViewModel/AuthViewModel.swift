//
//  AuthViewModel.swift
//  NoName
//
//  Created by 中島昂海 on 2024/03/24.
//

import Foundation
import Firebase

protocol AuthentiationFormProtocol {
    var formIsValid: Bool { get }
}

@MainActor
class AuthViewModel: ObservableObject {
    private let authRepository = AuthRepository()
    private let userRepository = UserRepository()
    @Published var userSession: FirebaseAuth.User?
    @Published var currentUser: UserData?
    
    init() {
        self.userSession = authRepository.currentUser()
        Task {
            try await fetchUser(uid: self.userSession!.uid)
        }
    }
    
    // ログイン
    func signIn(withEmail email: String, password: String) async throws {
        let result = try await authRepository.signIn(withEmail: email, password: password)
        self.userSession = result.user
        try await fetchUser(uid: self.userSession!.uid)
    }
    
    // 新規登録
    func createUser(withEmail email: String, password: String, fullname: String, accountName: String) async throws {
        do {
            let result = try await authRepository.createUser(withEmail: email, password: password)
            self.userSession = result.user
            let user = UserData(id: result.user.uid, fullname: fullname, email: email, accountName: accountName, dailyStepData: nil, weeklyStepData: nil)
            let encodedUser = try Firestore.Encoder().encode(user)
            try await userRepository.setUser(uid: user.id, encodedUser: encodedUser)
            try await fetchUser(uid: self.userSession!.uid)
        } catch {
            print("DEBUG: Failed to create user with error \(error.localizedDescription)")
        }
    }
    
    // ログアウト
    func signOut() async throws {
        try await authRepository.signOut()
        self.userSession = nil
        self.currentUser = nil
    }
    
    // ユーザ取得
    func fetchUser(uid: String) async throws {
        let snapshot = try await userRepository.getUser(uid: uid)
        self.currentUser = try snapshot.data(as: UserData.self)
        print("DEBUG: Current user is \(String(describing: self.currentUser?.fullname))")
    }
}
