import Foundation
import Firebase
import FirebaseFirestoreSwift

class UserRepository: ObservableObject {
    private let userCollectionRef: CollectionReference = Firestore.firestore().collection(Collection.users)
    
    // 初期処理
    init() {}
    
    // ユーザ作成
    func setUser(uid: String, encodedUser: [String : Any]) async throws {
        do {
            try await userCollectionRef.document(uid).setData(encodedUser)
        } catch {
            print("error in UserRepository.setUser()")
            throw error
        }
    }
    
    // ユーザ取得
    func getUser(uid: String) async throws -> DocumentSnapshot {
        do {
            let snapshot = try await userCollectionRef.document(uid).getDocument()
            return snapshot
        } catch {
            print("error in UserRepository.getUser()")
            throw error
        }
    }
    
    // 全ユーザ取得
    func getAllUsers() async throws -> [UserData] {
        do {
            let snapshot = try await userCollectionRef.getDocuments()
            let users = snapshot.documents.compactMap { document in
                let user = UserData.fromJson(json: document.data(), dailyStepData: nil, weeklyStepData: nil)
                return user
            }
            return users
        } catch {
            print("error in UserRepository.getUsers()")
            throw error
        }
    }
}
