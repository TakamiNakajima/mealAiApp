import Foundation
import UIKit

@MainActor
class AddPageViewModel: ObservableObject {
    private let recordRepository = RecordRepository()
    @Published var isLoading: Bool = false
    
    // 記録をDBに保存する
    func saveRecord(title: String, userId: String, selectedDate: Date, price: Int) async {
        DispatchQueue.main.async {
            self.isLoading = true
        }
        
        let recordId = UUID().uuidString.lowercased().replacingOccurrences(of: "-", with: "")
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateString = dateFormatter.string(from: selectedDate)
        let record = Record(id: recordId, title: title, date: dateString, price: price)
        
        do {
            try await recordRepository.createRecord(record: record, userId: userId)
        } catch {
            print("Error uploading image: \(error)")
        }
        
        DispatchQueue.main.async {
            self.isLoading = false
        }
    }
}
