import Foundation
import Firebase
import FirebaseStorage
import FirebaseFirestoreSwift

class ProfileEditPageViewModel: ObservableObject {
    let storageRepository = StorageRepository()
    let userRepository = UserRepository()
    
    // storageに画像を保存する
    func uploadImage(user: UserData, image: UIImage, storageRef: StorageReference) async throws -> URL {
        let storageRef = Storage.storage().reference(forURL: "gs://noname-383d9.appspot.com").child(user.id).child("profileImage")

        guard let imageData = image.jpegData(compressionQuality: 0.3) else {
            throw NSError(domain: "com.example.app", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to convert image to JPEG data."])
        }
        
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        
        do {
            try await storageRepository.saveImage(storageRef: storageRef, imageData: imageData, metadata: metadata)
            let downloadURL = try await storageRef.downloadURL()
            print("uploadImage")
            
            return downloadURL
        } catch {
            throw error
        }
    }
    
    // プロフィール画像を更新する
    func updateProfileData(user: UserData, imageURL: String) async throws {
        do {
            try await userRepository.updateUserData(uid: user.id, imageUrl: imageURL)
        } catch {
            print("error in TopPageViewModel.fetchAllUsers(): dailyStepData")
        }
    }
}
