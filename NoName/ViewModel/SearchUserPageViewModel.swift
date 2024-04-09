
import Foundation
import Firebase
import FirebaseFirestoreSwift

class SearchUserViewModel: ObservableObject {
    @Published var foundUser: UserData?
    
    // ユーザ検索
    func searchUser(accountCode: String) async throws {
        do {
            let querySnapshot = try await Firestore.firestore().collection(Collection.users).whereField(Field.accountName, isEqualTo: accountCode).getDocuments()
            
            if (querySnapshot.isEmpty) {
                return
            }
            
            let user = UserData.fromJson(json: querySnapshot.documents[0].data(), todayStep: nil)
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
