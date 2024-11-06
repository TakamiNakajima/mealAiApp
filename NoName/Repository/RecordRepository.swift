import Foundation
import Firebase
import FirebaseFirestoreSwift

class RecordRepository: ObservableObject {
    
    // 記録をDBに保存する
    func saveRecord(record: Record, userId: String) async throws {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateString = dateFormatter.string(from: record.date)
        let mealCollectionRef = Firestore.firestore().collection(Collection.users).document(userId).collection("records")
        do {
            try await mealCollectionRef.document("\(dateString)_\(record.type)").setData([
                "recordId": record.id,
                "title": record.title,
                "type": record.type,
                "date": record.date,
                "price": record.price,
                "imageUrl": record.imageURL,
                "timeStamp": FieldValue.serverTimestamp()
            ], mergeFields:  ["recordId","title", "type", "date", "price", "imageUrl", "timeStamp"])
            print("save record success")
        } catch {
            print("save record error \(error)")
            throw error
        }
    }
    
    // 記録をDBから取得する
    func fetchRecord(date: Date, type: Int, userId: String) async throws -> Record? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateString = dateFormatter.string(from: date)
        let mealCollectionRef = Firestore.firestore().collection(Collection.users).document(userId).collection("records")
        print("\(dateString)_\(type)")
        let docData = try await mealCollectionRef.document("\(dateString)_\(type)").getDocument().data()
        if let docData = docData {
            print("docData \(docData)")
            do {
                if let mealData = Record.fromJson(docData) {
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
