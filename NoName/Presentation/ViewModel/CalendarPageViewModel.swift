import Foundation
import SwiftUICore

@MainActor
class CalendarPageViewModel: ObservableObject {
    @Published var selectedDate = Date()

    // 月を変更する関数
    func changeMonth(by value: Int) {
        let calendar = Calendar.current
        if let newDate = calendar.date(byAdding: .month, value: value, to: self.selectedDate) {
            DispatchQueue.main.async {
                self.selectedDate = newDate
            }
        }
    }
    
    // 日付をフォーマットする関数
    func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.locale = Locale(identifier: "ja_JP") // 日本語フォーマット
        return formatter.string(from: date)
    }
    
    // 月をフォーマットする関数
    func formattedMonth(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy年 MM月"
        formatter.locale = Locale(identifier: "ja_JP")
        return formatter.string(from: date)
    }
}
