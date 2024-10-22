import Foundation
import UIKit

@MainActor
class AddPageViewModel: ObservableObject {
    @Published var isLoading: Bool = false
    
    func saveMeal(type: Int, image: UIImage, userId: String) async {
        DispatchQueue.main.async {
            self.isLoading = true
        }
        let storageRepository = StorageRepository()
        var imageURL: String?
        let mealId = UUID().uuidString
        
        do {
            let downloadURL = try await storageRepository.uploadImageToFirebaseStorage(image: image, userId: userId, mealId: mealId)
            print("Image uploaded successfully! Download URL: \(downloadURL)")
            imageURL = downloadURL
        } catch {
            print("Error uploading image: \(error)")
        }
        
        let currentDate = Date()
        let meal = Meal(id: mealId, type: type, date: currentDate, imageURL: imageURL)
        
        do {
            let mealRepository = MealRepository()
            try await mealRepository.saveMeal(meal: meal, userId: userId)
            print("save meal successfully!")
        } catch {
            print("Error uploading image: \(error)")
        }
        
        DispatchQueue.main.async {
            self.isLoading = false
        }
    }
}
