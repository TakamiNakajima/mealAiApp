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
                "kcal": meal.kcal,
                "imageUrl": meal.imageURL,
                "timeStamp": FieldValue.serverTimestamp()
            ], mergeFields:  ["mealId", "type", "date", "kcal", "imageUrl", "timeStamp"])
            print("save meal success")
        } catch {
            print("save meal error \(error)")
            throw error
        }
    }
    
    // 食事記録をDBから取得する
    func fetchMeal(date: Date, type: Int, userId: String) async throws -> Meal? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateString = dateFormatter.string(from: date)
        let mealCollectionRef = Firestore.firestore().collection(Collection.users).document(userId).collection("meals")
        print("\(dateString)_\(type)")
        let docData = try await mealCollectionRef.document("\(dateString)_\(type)").getDocument().data()
        if let docData = docData {
            print("docData \(docData)")
            do {
                if let mealData = Meal.fromJson(docData) {
                    return mealData
                } else {
                    print("Failed to decode meal data.")
                }
            }
        } else {
            print("Document does not exist.")
        }
        return nil
    }
}
