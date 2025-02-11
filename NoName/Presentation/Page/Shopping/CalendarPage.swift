import SwiftUI

struct CalendarPage: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject var viewModel: CalendarPageViewModel
    @State var calendarItems: [CalendarItem] = []
    @State var selectedDate = Date()
    @State var isLoading: Bool = false
    
    var body: some View {
        if let currentUser = authViewModel.currentUser {
            ZStack {
                VStack {
                    HStack {
                        Button(action: {
                            let calendar = Calendar.current
                            if let newDate = calendar.date(byAdding: .month, value: -1, to: self.selectedDate) {
                                selectedDate = newDate
                            }
                            Task {
                                await fetchCalendar(userId: currentUser.id)
                            }
                        }) {
                            Image(systemName: "chevron.left")
                                .font(.title)
                                .foregroundColor(Color("mainColorDark"))
                        }
                        
                        Spacer()
                        
                        Text("\(viewModel.formattedMonth(selectedDate))")
                            .font(.headline)
                        
                        Spacer()
                        
                        Button(action: {
                            let calendar = Calendar.current
                            if let newDate = calendar.date(byAdding: .month, value: +1, to: self.selectedDate) {
                                selectedDate = newDate
                            }
                            Task {
                                await fetchCalendar(userId: currentUser.id)
                            }
                        }) {
                            Image(systemName: "chevron.right")
                                .font(.title)
                                .foregroundColor(Color("mainColorDark"))
                        }
                    }
                    .padding()
                    
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7)) {
                        ForEach(calendarItems, id: \.date) { item in
                            CalendarComponent(calendarItem: item, selectedDate: selectedDate)
                        }
                    }
                    .padding()
                    
                    Spacer()
                }
                .onAppear {
                    Task {
                        await fetchCalendar(userId: currentUser.id)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding()
                
                // ローディング表示
                if isLoading {
                    Color.white.opacity(0.6)
                        .ignoresSafeArea()
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                        .scaleEffect(2)
                }
            }
        }
    }
    
    // カレンダー情報を取得する
    private func fetchCalendar(userId: String) async {
        DispatchQueue.main.async {
            self.isLoading = true
        }
        
        let items = await viewModel.fetchCalendarItems(daysInMonth: daysInMonth, userId: userId)
        
        DispatchQueue.main.async {
            self.calendarItems = items
            self.isLoading = false
        }
    }
    
    // 選択月の日付のリストを取得する
    private var daysInMonth: [Date] {
        let calendar = Calendar.current
        let startOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: selectedDate))!
        
        let range = calendar.range(of: .day, in: .month, for: startOfMonth)!
        return range.compactMap { day -> Date? in
            calendar.date(byAdding: .day, value: day - 1, to: startOfMonth)
        }
    }
}
