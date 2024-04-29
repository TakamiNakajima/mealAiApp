import Foundation
import Firebase
import FirebaseFirestoreSwift
import FirebaseStorage


class StorageRepository: ObservableObject {
    // 保存
    func saveImage(storageRef: StorageReference, imageData: Data, metadata: StorageMetadata) async throws {
        try await storageRef.putData(imageData, metadata: metadata)
    }
}
