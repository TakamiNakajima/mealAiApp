//
//  Date.swift
//  NoName
//
//  Created by 中島昂海 on 2024/04/03.
//

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

func remainingTimeUntilNextSunday21() -> TimeInterval? {
    let calendar = Calendar(identifier: .gregorian)
    // 今日の日付を取得
    let today = Date()
    
    // 今週の月曜日の日付を取得
    guard let monday = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: today)),
        let sunday = calendar.date(byAdding: .day, value: 6, to: monday),
        let nextSunday21 = calendar.date(bySettingHour: 21, minute: 0, second: 0, of: sunday) else {
            return nil
    }
    
    // 今日から次の日曜日の21時までの残り時間を計算
    let remainingTime = nextSunday21.timeIntervalSince(today)
    return remainingTime
}
