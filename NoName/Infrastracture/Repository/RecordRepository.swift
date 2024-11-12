import Foundation
import Firebase
import FirebaseFirestoreSwift

class RecordRepository: ObservableObject {
    
    // 記録をDBに保存する
    func createRecord(record: Record, userId: String) async throws {
        let mealCollectionRef = Firestore.firestore().collection(Collection.users).document(userId).collection("records")
        do {
            try await mealCollectionRef.document("\(record.id)").setData([
                "recordId": record.id,
                "title": record.title,
                "type": record.type,
                "date": record.date,
                "price": record.price,
                "timeStamp": FieldValue.serverTimestamp()
            ], mergeFields: ["recordId","title", "type", "date", "price", "timeStamp"])
            print("save record success")
        } catch {
            print("save record error \(error)")
            throw error
        }
    }
    
    func readRecord(date: Date, userId: String) async throws -> [Record] {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateString = dateFormatter.string(from: date)
        
        let recordCollectionRef = Firestore.firestore().collection(Collection.users).document(userId).collection("records")
        let querySnapshot = try await recordCollectionRef
            .whereField("date", isEqualTo: dateString)
            .getDocuments()
        
        var records: [Record] = []
        for document in querySnapshot.documents {
            if let recordData = Record.fromJson(document.data()) {
                records.append(recordData)
            } else {
                print("Failed to decode meal data for document \(document.documentID).")
            }
        }
        
        if records.isEmpty {
            return []
        } else {
            return records
        }
    }
}
