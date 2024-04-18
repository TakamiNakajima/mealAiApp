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
            do {
                try await fetchUser(uid: self.userSession!.uid)
            } catch {
                print("error: AuthViewModel.init()")
                throw error
            }
        }
    }
    
    // ログイン
    func signIn(withEmail email: String, password: String) async throws {
        let result: AuthDataResult
        do {
            result = try await authRepository.signIn(withEmail: email, password: password)
        } catch {
            print("error: AuthViewModel.signIn()")
            throw error
        }
        
        self.userSession = result.user
        
        do {
            try await fetchUser(uid: self.userSession!.uid)
        } catch {
            print("error: AuthViewModel.fetchUser()")
            throw error
        }
    }
    
    // 新規登録
    func createUser(withEmail email: String, password: String, fullname: String, accountName: String) async throws {
        let result: AuthDataResult
        do {
            result = try await authRepository.createUser(withEmail: email, password: password)
        } catch {
            print("error: AuthViewModel.createUser()")
            throw error
        }
        
        self.userSession = result.user
        let user = UserData(id: result.user.uid, fullname: fullname, email: email, accountName: accountName, dailyStepData: nil, weeklyStepData: nil)
        let encodedUser = try Firestore.Encoder().encode(user)
        
        do {
            try await userRepository.setUser(uid: user.id, encodedUser: encodedUser)
        } catch {
            print("error in AuthViewModel.setUser()")
            throw error
        }
        
        do {
            try await fetchUser(uid: self.userSession!.uid)
        } catch {
            print("error in AuthViewModel.fetchUser()")
            throw error
        }
    }
    
    // ログアウト
    func signOut() async throws {
        do {
            try await authRepository.signOut()
        } catch {
            print("error in AuthViewModel.signOut()")
            throw error
        }
        self.userSession = nil
        self.currentUser = nil
    }
    
    // ユーザ取得
    func fetchUser(uid: String) async throws {
        let snapshot: DocumentSnapshot
        
        do {
            snapshot = try await userRepository.getUser(uid: uid)
        } catch {
            print("error: AuthViewModel.fetchUser()")
            throw error
        }
        
        self.currentUser = try snapshot.data(as: UserData.self)
        print("DEBUG: Current user is \(String(describing: self.currentUser?.fullname))")
    }
}
