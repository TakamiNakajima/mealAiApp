import Foundation
import Firebase
import FirebaseFirestoreSwift

class UserRepository: ObservableObject {
    
    // 初期処理
    init() {}
    
    func getUsers() async throws -> [UserData] {
        do {
            let usersCollectionRef = Firestore.firestore().collection(Collection.users)
            let snapshot = try await usersCollectionRef.getDocuments()
            let users = snapshot.documents.compactMap { document in
                let user = UserData.fromJson(json: document.data(), dailyStepData: nil, weeklyStepData: nil)
                return user
            }
            return users
        } catch {
            print("error UserRepository.getUsers()")
            throw error
        }
    }
}
