import Foundation
import UIKit
import FirebaseStorage

class StorageRepository: ObservableObject {
    
    // 画像をFirebaseStoregeに保存して画像URLを返却する
    func uploadImage(image: UIImage, userId: String, recordId: String) async throws -> String {
        let storageRef = Storage.storage().reference()
        
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            throw NSError(domain: "ImageError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to convert image to data"])
        }
        
        let fileName = "records/\(userId)/\(recordId).jpg"
        let imageRef = storageRef.child(fileName)
        
        let _ = try await imageRef.putDataAsync(imageData, metadata: nil)
        let url = try await imageRef.downloadURL()
        
        return url.absoluteString
    }
}
