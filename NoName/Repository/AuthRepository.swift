import Foundation
import Firebase
import FirebaseAuth
import FirebaseFirestoreSwift
import FirebaseStorage


class AuthRepository: ObservableObject {
    // ログイン
    func signIn(withEmail email: String, password: String) async throws -> AuthDataResult {
        return try await Auth.auth().signIn(withEmail: email, password: password)
    }
    
    // ログアウト
    func signOut() async throws {
        try Auth.auth().signOut()
    }
    
    // 新規登録
    func createUser(withEmail email: String, password: String) async throws -> AuthDataResult {
        return try await Auth.auth().createUser(withEmail: email, password: password)
    }
    
    // ログインユーザ情報
    func currentUser() -> User? {
        return Auth.auth().currentUser
    }
}
