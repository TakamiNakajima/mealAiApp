import Firebase
import FirebaseFirestore
import Foundation

struct FirestoreService {
    private let db = Firestore.firestore()
    
    // ドキュメントを新規作成
    func create(collection: String, data: [String: Any], completion: @escaping (Result<Void, Error>) -> Void) {
        db.collection(collection).addDocument(data: data) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
    
    // コレクション内のドキュメントを全取得
    func read(collection: String, completion: @escaping (Result<[DocumentSnapshot], Error>) -> Void) {
        db.collection(collection).getDocuments { snapshot, error in
            if let error = error {
                completion(.failure(error))
            } else if let snapshot = snapshot {
                completion(.success(snapshot.documents))
            }
        }
    }
    
    // ドキュメントを取得
    func readDocument(collection: String, documentId: String, completion: @escaping (Result<DocumentSnapshot, Error>) -> Void) {
        db.collection(collection).document(documentId).getDocument { document, error in
            if let error = error {
                completion(.failure(error))
            } else if let document = document, document.exists {
                completion(.success(document))
            } else {
                completion(.failure(NSError(domain: "FirestoreService", code: 404, userInfo: [NSLocalizedDescriptionKey: "Document not found."])))
            }
        }
    }
    
    // ドキュメントを更新
    func update(collection: String, documentId: String, data: [String: Any], completion: @escaping (Result<Void, Error>) -> Void) {
        db.collection(collection).document(documentId).updateData(data) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
    
    // ドキュメントを削除
    func delete(collection: String, documentId: String, completion: @escaping (Result<Void, Error>) -> Void) {
        db.collection(collection).document(documentId).delete { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
    
    // サブコレクションにデータを保存
    func createInSubCollection(
        parentCollection: String,
        parentDocumentId: String,
        subCollection: String,
        data: [String: Any],
        subDocumentId: String? = nil
    ) async throws {
        let reference: DocumentReference
        
        if let subDocumentId = subDocumentId {
            // サブコレクション内で特定のドキュメントIDを指定
            reference = db.collection(parentCollection)
                .document(parentDocumentId)
                .collection(subCollection)
                .document(subDocumentId)
        } else {
            // 自動生成されたドキュメントIDで追加
            reference = db.collection(parentCollection)
                .document(parentDocumentId)
                .collection(subCollection)
                .document()
        }
        
        // 非同期でデータをセット
        try await reference.setData(data)
    }
    
    // サブコレクションのデータを取得
    func readInSubCollection(
        parentCollection: String,
        parentDocumentId: String,
        subCollection: String,
        field: String,
        isEqualTo value: Any,
        completion: @escaping (Result<[QueryDocumentSnapshot], Error>) -> Void
    ) {
        let reference = db.collection(parentCollection)
            .document(parentDocumentId)
            .collection(subCollection)
            .whereField(field, isEqualTo: value)

        reference.getDocuments { snapshot, error in
            if let error = error {
                completion(.failure(error))
            } else if let documents = snapshot?.documents {
                completion(.success(documents))
            } else {
                completion(.failure(NSError(domain: "FirestoreService", code: 404, userInfo: [NSLocalizedDescriptionKey: "No documents found."])))
            }
        }
    }
    
    // サブコレクション内の特定のドキュメントを更新
    func updateInSubCollection(
        parentCollection: String,
        parentDocumentId: String,
        subCollection: String,
        subDocumentId: String,
        data: [String: Any],
        completion: @escaping (Result<Void, Error>) -> Void
    ) {
        let reference = db.collection(parentCollection)
            .document(parentDocumentId)
            .collection(subCollection)
            .document(subDocumentId)
        
        reference.updateData(data) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
    
    // サブコレクション内の特定のドキュメントを削除
    func deleteInSubCollection(
        parentCollection: String,
        parentDocumentId: String,
        subCollection: String,
        subDocumentId: String,
        completion: @escaping (Result<Void, Error>) -> Void
    ) {
        let reference = db.collection(parentCollection)
            .document(parentDocumentId)
            .collection(subCollection)
            .document(subDocumentId)
        
        reference.delete { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
    
}
