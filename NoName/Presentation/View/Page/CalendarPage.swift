import SwiftUI

struct CalendarPage: View {
    @EnvironmentObject var viewModel: CalendarPageViewModel    
    // カレンダーに表示する月の日付リストを生成
    private var daysInMonth: [Date] {
        let calendar = Calendar.current
        let startOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: viewModel.selectedDate))!
        let range = calendar.range(of: .day, in: .month, for: startOfMonth)!
        return range.compactMap { day -> Date? in
            calendar.date(byAdding: .day, value: day - 1, to: startOfMonth)
        }
    }
    
    var body: some View {
        VStack {
            // 月変更ボタンと現在の月を表示
            HStack {
                Button(action: {
                    viewModel.changeMonth(by: -1)
                }) {
                    Image(systemName: "chevron.left")
                        .font(.title)
                        .foregroundColor(.blue)
                }
                
                Spacer()
                
                Text("\(viewModel.formattedMonth(viewModel.selectedDate))")
                    .font(.headline)
                
                Spacer()
                
                Button(action: {
                    viewModel.changeMonth(by: 1)
                }) {
                    Image(systemName: "chevron.right")
                        .font(.title)
                        .foregroundColor(.blue)
                }
            }
            .padding()
            
            // カレンダー上部に選択された日付を表示
            Text("選択された日付: \(viewModel.formattedDate(viewModel.selectedDate))")
                .font(.headline)
                .padding()
            
            // カレンダーのグリッド
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7)) {
                ForEach(daysInMonth, id: \.self) { date in
                    CalendarView(date: date, selectedDate: viewModel.selectedDate)
                        .onTapGesture {
                            // 日付をタップしたら選択
                            DispatchQueue.main.async {
                                viewModel.selectedDate = date
                            }
                        }
                }
            }
            .padding()
            
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
    }
}
