import Foundation
import UIKit

@MainActor
class AddPageViewModel: ObservableObject {
    @Published var isLoading: Bool = false
    
    // 記録をDBに保存する
    func saveRecord(type: Int, title: String, userId: String, date: String, price: Int) async {
        DispatchQueue.main.async {
            self.isLoading = true
        }
        
        let recordId = UUID().uuidString.lowercased().replacingOccurrences(of: "-", with: "")
        
        let record = Record(id: recordId, title: title, type: type, date: date, price: price)
        do {
            let recordRepository = RecordRepository()
            try await recordRepository.createRecord(record: record, userId: userId)
            print("save record successfully!")
        } catch {
            print("Error uploading image: \(error)")
        }
        
        DispatchQueue.main.async {
            self.isLoading = false
        }
    }
}
