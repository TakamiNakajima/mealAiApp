import Foundation
import SwiftUICore

@MainActor
class CalendarPageViewModel: ObservableObject {
    private let recordRepository = RecordRepository()
    @Published private var cachedItems: [Date: CalendarItem] = [:]
    
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
    
    func fetchCalendarItems(daysInMonth: [Date], userId: String) async -> [CalendarItem] {
        do {
            var items: [CalendarItem] = []
            
            for date in daysInMonth {
                if let cachedItem = cachedItems[date] {
                    items.append(cachedItem)
                } else {
                    let records = try await recordRepository.readRecord(date: date, userId: userId)
                    let totalPrice = records.reduce(0) { $0 + $1.price }
                    let newItem = CalendarItem(date: date, price: totalPrice)
                    
                    cachedItems[date] = newItem
                    items.append(newItem)
                }
            }
            return items
        } catch {
            print("Error fetching calendar items: \(error)")
            return []
        }
    }
}
