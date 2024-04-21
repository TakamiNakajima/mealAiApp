import Foundation
import Firebase
import FirebaseFirestoreSwift

class SearchUserViewModel: ObservableObject {
    @Published var foundUser: UserData?
    
    // ユーザ検索
    func searchUser(accountCode: String) async throws {
        let collectionRef = Firestore.firestore().collection(Collection.users)
        
        do {
            let querySnapshot = try await collectionRef.whereField(Field.accountName, isEqualTo: accountCode).getDocuments()
            if (querySnapshot.isEmpty) {
                print("can't found user")
                return
            }
            
            let user = UserData.fromJson(json: querySnapshot.documents[0].data(), dailyStepData: nil, weeklyStepData: nil)
            print("user: \(user!.fullname)")
            DispatchQueue.main.async {
                self.foundUser = user
            }
        } catch {
            print("Error getting documents: \(error)")
            throw error
        }
    }
}
