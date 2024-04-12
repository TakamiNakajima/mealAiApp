//
//  Calendar.swift
//  NoName
//
//  Created by Takami Nakajima on 2024/04/12.
//

import Foundation

extension Calendar {
    func initialDayOfWeek() -> Date {
        var japanCalendar = Calendar(identifier: .japanese)
        let japanTimeZone = TimeZone(identifier: "Asia/Tokyo")!
        japanCalendar.timeZone = japanTimeZone
        
        let japanNow = Date().addingTimeInterval(TimeInterval(japanTimeZone.secondsFromGMT(for: Date())))
        let todaysStart = Calendar.current.date(byAdding: .hour, value: -15, to: Calendar.current.startOfDay(for: japanNow))!
        let weekday = japanCalendar.component(.weekday, from: Date())
        
        switch weekday {
        case 2:
            return japanCalendar.date(byAdding: .day, value: 0, to: todaysStart)!
        case 3:
            return japanCalendar.date(byAdding: .day, value: -1, to: todaysStart)!
        case 4:
            return japanCalendar.date(byAdding: .day, value: -2, to: todaysStart)!
        case 5:
            return japanCalendar.date(byAdding: .day, value: -3, to: todaysStart)!
        case 6:
            return japanCalendar.date(byAdding: .day, value: -4, to: todaysStart)!
        case 7:
            return japanCalendar.date(byAdding: .day, value: -5, to: todaysStart)!
        default:
            return japanCalendar.date(byAdding: .day, value: -6, to: todaysStart)!
        }
    }
}
