import SwiftUI

struct CalendarComponent: View {
    let calendarItem: CalendarItem
    let selectedDate: Date

    var body: some View {
        VStack {
            // 日付を表示
            Text("\(dayNumber(from: calendarItem.date))")
                .font(.body)
                .foregroundColor(isSameDay(date1: calendarItem.date, date2: selectedDate) ? .white : .primary)
                .frame(width: 36, height: 36)
                .background(
                    Group {
                        if isSameDay(date1: calendarItem.date, date2: selectedDate) {
                            LinearGradient(
                                gradient: Gradient(colors: [Color("mainColorLight"), Color("mainColorDark")]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                            .clipShape(Circle())
                        } else {
                            Color.clear
                        }
                    }
                )
            
            // 日付の下に文字を表示
            Text("¥\(String(calendarItem.price))")
                .font(.caption)
                .foregroundColor(.gray)
        }
    }
    
    // 同じ日付かどうかを確認する関数
    private func isSameDay(date1: Date, date2: Date) -> Bool {
        let calendar = Calendar.current
        return calendar.isDate(date1, inSameDayAs: date2)
    }
    
    // 日付から日番号を抽出
    private func dayNumber(from date: Date) -> String {
        let calendar = Calendar.current
        return String(calendar.component(.day, from: date))
    }
}
