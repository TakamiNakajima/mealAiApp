import Foundation
import UIKit

@MainActor
class AddPageViewModel: ObservableObject {
    @Published var isLoading: Bool = false
    
    // 食事記録をDBに保存する
    func saveMeal(type: Int, image: UIImage, userId: String, date: Date, kcal: Int) async {
        DispatchQueue.main.async {
            self.isLoading = true
        }
        
        let storageRepository = StorageRepository()
        var imageURL: String?
        let mealId = UUID().uuidString
        
        do {
            let downloadURL = try await storageRepository.uploadImage(image: image, userId: userId, mealId: mealId)
            print("Image uploaded successfully! Download URL: \(downloadURL)")
            imageURL = downloadURL
        } catch {
            print("Error uploading image: \(error)")
        }
        
        let meal = Meal(id: mealId, type: type, date: date, imageURL: imageURL, kcal: kcal)
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
