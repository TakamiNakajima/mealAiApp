import Foundation
import UIKit

@MainActor
class AddPageViewModel: ObservableObject {
    @Published var isLoading: Bool = false
    
    // 記録をDBに保存する
    func saveRecord(type: Int, title: String, image: UIImage, userId: String, date: Date, price: Int) async {
        DispatchQueue.main.async {
            self.isLoading = true
        }
        
        let storageRepository = StorageRepository()
        var imageURL: String?
        let recordId = UUID().uuidString
        
        do {
            let downloadURL = try await storageRepository.uploadImage(image: image, userId: userId, recordId: recordId)
            print("Image uploaded successfully! Download URL: \(downloadURL)")
            imageURL = downloadURL
        } catch {
            print("Error uploading image: \(error)")
        }
        
        let record = Record(id: recordId,title: title, type: type, date: date, imageURL: imageURL, price: price)
        do {
            let recordRepository = RecordRepository()
            try await recordRepository.saveRecord(record: record, userId: userId)
            print("save record successfully!")
        } catch {
            print("Error uploading image: \(error)")
        }
        
        DispatchQueue.main.async {
            self.isLoading = false
        }
    }
}
