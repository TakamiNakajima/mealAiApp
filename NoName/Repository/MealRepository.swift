import Foundation
import Firebase
import FirebaseFirestoreSwift

class MealRepository: ObservableObject {
    
    // 食事記録をDBに保存する
    func saveMeal(meal: Meal, userId: String) async throws {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateString = dateFormatter.string(from: meal.date)
        let mealCollectionRef = Firestore.firestore().collection(Collection.users).document(userId).collection("meals")
        do {
            try await mealCollectionRef.document("\(dateString)_\(meal.type)").setData([
                "mealId": meal.id,
                "type": meal.type,
                "date": meal.date,
                "imageUrl": meal.imageURL,
                "timeStamp": FieldValue.serverTimestamp()
            ], mergeFields:  ["mealId", "type", "date", "imageUrl", "timeStamp"])
            print("save meal success")
        } catch {
            print("save meal error \(error)")
            throw error
        }
    }
}
