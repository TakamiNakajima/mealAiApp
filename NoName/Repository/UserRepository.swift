import Foundation
import Firebase
import FirebaseFirestoreSwift

// Userコレクションへアクセスする
class UserRepository: ObservableObject {
    private let userCollectionRef: CollectionReference = Firestore.firestore().collection(Collection.users)
    
    // ユーザを作成する
    func setUser(uid: String, encodedUser: [String : Any]) async throws {
        try await userCollectionRef.document(uid).setData(encodedUser)
    }
    
    // ユーザを取得する
    func getUser(uid: String) async throws -> DocumentSnapshot {
        return try await userCollectionRef.document(uid).getDocument()
    }
    
    // 全ユーザを取得する
    func getAllUsers() async throws -> QuerySnapshot {
        return try await userCollectionRef.getDocuments()
    }
    
    // ユーザーデータを更新する
    func updateUserData(uid: String, imageUrl: String) async throws {
        try await userCollectionRef.document(uid).updateData(["imageUrl": imageUrl])
    }
}
