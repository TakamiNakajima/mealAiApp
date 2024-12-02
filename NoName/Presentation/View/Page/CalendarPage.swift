import SwiftUI

struct CalendarPage: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject var viewModel: CalendarPageViewModel
    @State var calendarItems: [CalendarItem] = []
    
    private var daysInMonth: [Date] {
        let calendar = Calendar.current
        let startOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: Date()))!
        
        let range = calendar.range(of: .day, in: .month, for: startOfMonth)!
        return range.compactMap { day -> Date? in
            calendar.date(byAdding: .day, value: day - 1, to: startOfMonth)
        }
    }
    
    var body: some View {
        if let currentUser = authViewModel.currentUser {
            VStack {
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
                
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7)) {
                    ForEach(calendarItems, id: \.date) { item in
                        CalendarView(calendarItem: item, selectedDate: viewModel.selectedDate)
                    }
                }
                .padding()
                
                Spacer()
            }
            .onAppear {
                Task {
                    let items = await viewModel.fetchCalendarItems(daysInMonth: daysInMonth, userId: currentUser.id)
                    DispatchQueue.main.async {
                        self.calendarItems = items
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding()
        }
    }
}
