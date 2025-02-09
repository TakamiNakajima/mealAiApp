import Foundation

class RecordRepository: ObservableObject {
    private let firestoreDataSource = FirestoreDataSource()
    
    // レコード作成処理
    func createRecord(record: Record, userId: String) async throws {
        do {
            try await firestoreDataSource.createSubCollection(parentCollection: "users", parentDocumentId: userId, subCollection: "records", data: [
                "recordId": record.id,
                "title": record.title,
                "date": record.date,
                "price": record.price,
                "timeStamp": Date()
            ], subDocumentId: record.id)
        } catch {
            print("save record error \(error)")
            throw error
        }
    }
    
    // レコード取得処理
    func readRecord(date: Date, userId: String) async throws -> [Record] {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateString = dateFormatter.string(from: date)
        
        return try await withCheckedThrowingContinuation { continuation in
            firestoreDataSource.readSubCollection(
                parentCollection: "users",
                parentDocumentId: userId,
                subCollection: "records",
                field: "date",
                isEqualTo: dateString
            ) { result in
                switch result {
                case .success(let documents):
                    var records: [Record] = []
                    for document in documents {
                        if let recordData = Record.fromJson(document.data()) {
                            records.append(recordData)
                        } else {
                            print("Failed to decode meal data for document \(document.documentID).")
                        }
                    }
                    continuation.resume(returning: records)
                    
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    
    // レコード削除処理
    func deleteRecord(recordId: String, userId: String) async throws {
        firestoreDataSource.deleteSubCollection(parentCollection: "users", parentDocumentId: userId, subCollection: "records", subDocumentId: recordId, completion: { result in
            switch result {
            case .success():
                print("ドキュメントが正常に削除されました。")
            case .failure(let error):
                print("エラーが発生しました: \(error.localizedDescription)")
            }
        })
    }
}
