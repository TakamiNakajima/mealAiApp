import Foundation
import Firebase
import FirebaseAuth
import FirebaseFirestoreSwift

class AuthRepository: ObservableObject {
    
    // 初期処理
    init() {}
    
    // ログイン
    func signIn(withEmail email: String, password: String) async throws -> AuthDataResult {
        do {
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            return result
        } catch {
            print("error in AuthRepository.signIn()")
            throw error
        }
    }
    
    // ログアウト
    func signOut() async throws {
        do {
            try Auth.auth().signOut()
        } catch {
            print("error in AuthRepository.signOut()")
            throw error
        }
    }
    
    // 新規登録
    func createUser(withEmail email: String, password: String) async throws -> AuthDataResult {
        do {
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            return result
        } catch {
            print("error in AuthRepository.createUser()")
            throw error
        }
    }
    
    // ログインユーザを取得
    func currentUser() -> User? {
        return Auth.auth().currentUser
    }
}
