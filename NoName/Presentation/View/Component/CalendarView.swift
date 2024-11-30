import SwiftUI

struct CalendarView: View {
    let date: Date
    let selectedDate: Date

    var body: some View {
        VStack {
            // 日付を表示
            Text("\(dayNumber(from: date))")
                .font(.body)
                .foregroundColor(isSameDay(date1: date, date2: selectedDate) ? .white : .primary)
                .frame(width: 40, height: 40)
                .background(isSameDay(date1: date, date2: selectedDate) ? Color.blue : Color.clear)
                .clipShape(Circle())
            
            // 日付の下に文字を表示
            Text("イベントあり")
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
