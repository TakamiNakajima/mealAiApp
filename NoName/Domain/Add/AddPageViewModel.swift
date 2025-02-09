import Foundation
import SwiftUI
import UIKit

@MainActor
class AddPageViewModel: ObservableObject {
    private let recordRepository = RecordRepository()
    
    // 支出を保存する
    func saveRecord(title: String, userId: String, selectedDate: Date, price: Int) async {
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
    }
}
