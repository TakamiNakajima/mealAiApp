import Foundation

extension Date {
    
    // フォーマット(例: 2024-12-08)
    func dateString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateString = dateFormatter.string(from: self)
        return dateString
    }
    
    // 時間表示用フォーマット
    func displayDateString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "M/d HH:mm"
        let dateString = dateFormatter.string(from: self)
        return dateString
    }
    
    // 今週月曜日の日付を取得
    func initialDayOfWeek() -> Date {
        let calendar = Calendar(identifier: .gregorian)
        let today = calendar.startOfDay(for: Date())
        let weekNumber = calendar.component(.weekday, from: today)
        
        if weekNumber == 1 {
            return calendar.date(byAdding: .day, value: -6, to: today)!
        } else {
            return calendar.date(byAdding: .day, value: -(weekNumber - 2), to: today)!
        }
    }
    
}
