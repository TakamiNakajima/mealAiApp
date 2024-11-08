import Foundation
import Firebase
import FirebaseFirestoreSwift

class RecordRepository: ObservableObject {
    
    // 記録をDBに保存する
    func saveRecord(record: Record, userId: String) async throws {
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
    
    // 記録をDBから取得する
//    func fetchRecord(date: Date, type: Int, userId: String) async throws -> Record? {
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "yyyy-MM-dd"
//        let dateString = dateFormatter.string(from: date)
//        let recordCollectionRef = Firestore.firestore().collection(Collection.users).document(userId).collection("records")
//        let docData = try await recordCollectionRef.document("\(dateString)_\(type)").getDocument().data()
//        if let docData = docData {
//            print("docData \(docData)")
//            do {
//                if let recordData = Record.fromJson(docData) {
//                    return recordData
//                } else {
//                    print("Failed to decode meal data.")
//                }
//            }
//        } else {
//            print("Document does not exist.")
//        }
//        return nil
//    }
    
    func fetchRecords(date: Date, userId: String) async throws -> [Record] {
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
