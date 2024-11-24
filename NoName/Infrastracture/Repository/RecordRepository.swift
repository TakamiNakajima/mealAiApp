import Foundation
import Firebase
import FirebaseFirestoreSwift

class RecordRepository: ObservableObject {
    
    private let firestoreService = FirestoreService()
    
    // 記録をDBに保存する
    func createRecord(record: Record, userId: String) async throws {
        do {
            try await firestoreService.createInSubCollection(parentCollection: "users", parentDocumentId: userId, subCollection: "records", data: [
                "recordId": record.id,
                "title": record.title,
                "date": record.date,
                "price": record.price,
                "timeStamp": FieldValue.serverTimestamp()
            ])
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
    
    func deleteRecord(recordId: String, userId: String) async throws {
        let recordCollectionRef = Firestore.firestore()
            .collection(Collection.users)
            .document(userId)
            .collection("records")
        
        let querySnapshot = try await recordCollectionRef.whereField("recordId", isEqualTo: recordId).getDocuments()
        
        for document in querySnapshot.documents {
            try await document.reference.delete()
        }
        print("Record deleted successfully.")
    }
}
