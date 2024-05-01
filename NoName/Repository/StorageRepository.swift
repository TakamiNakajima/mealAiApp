import Foundation
import Firebase
import FirebaseFirestoreSwift
import FirebaseStorage

// storageへアクセスする
class StorageRepository: ObservableObject {
    // 画像保存
    func saveImage(storageRef: StorageReference, imageData: Data, metadata: StorageMetadata) {
        storageRef.putData(imageData, metadata: metadata)
    }
}
