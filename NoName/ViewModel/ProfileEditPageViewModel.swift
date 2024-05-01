import Foundation
import Firebase
import FirebaseStorage
import FirebaseFirestoreSwift

class ProfileEditPageViewModel: ObservableObject {
    let storageRepository = StorageRepository()
    let userRepository = UserRepository()
    let storageURL = "gs://noname-383d9.appspot.com"
    
    // storageに画像を保存する
    func uploadImage(user: UserData, image: UIImage, storageRef: StorageReference) async throws -> URL {
        let storageRef = Storage.storage().reference(forURL: storageURL).child(user.id).child("profileImage")

        guard let imageData = image.jpegData(compressionQuality: 0.3) else {
            throw NSError(domain: "com.example.app", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to convert image to JPEG data."])
        }
        
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        
        storageRepository.saveImage(storageRef: storageRef, imageData: imageData, metadata: metadata)
        
        do {
            let downloadURL = try await storageRef.downloadURL()
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
