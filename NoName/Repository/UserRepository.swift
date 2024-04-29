import Foundation
import Firebase
import FirebaseFirestoreSwift

class UserRepository: ObservableObject {
    private let userCollectionRef: CollectionReference = Firestore.firestore().collection(Collection.users)
    
    // ユーザ作成
    func setUser(uid: String, encodedUser: [String : Any]) async throws {
        try await userCollectionRef.document(uid).setData(encodedUser)
    }
    
    // ユーザ取得
    func getUser(uid: String) async throws -> DocumentSnapshot {
        return try await userCollectionRef.document(uid).getDocument()
    }
    
    // 全ユーザ取得
    func getAllUsers() async throws -> QuerySnapshot {
        return try await userCollectionRef.getDocuments()
    }
    
    // ユーザーデータ更新
    func updateUserData(uid: String, imageUrl: String) async throws {
        try await userCollectionRef.document(uid).updateData(["imageUrl": imageUrl])
    }
}
