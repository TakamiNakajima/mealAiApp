import Foundation
import UIKit
import SwiftUICore

@MainActor
class GenerateMenuViewModel: ObservableObject {
    let generator = UIImpactFeedbackGenerator(style: .light)
    
    func onSelectDate(dates: Set<DateComponents>, startDate: Binding<Date?>, endDate: Binding<Date?>, pageState: Binding<GeneratePageState>) {
        generator.impactOccurred()
        let sortedDates = dates.compactMap { Calendar.current.date(from: $0) }.sorted()
        if (sortedDates.count == 1) {
            startDate.wrappedValue = sortedDates.first
            pageState.wrappedValue = .second
        } else if (sortedDates.count == 2) {
            endDate.wrappedValue = sortedDates.last
            pageState.wrappedValue = .third
        }
    }
    
    func formattedDate(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ja_JP")
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter.string(from: date)
    }
    
    func onTapBackButton(isPresented: Binding<Bool>) {
        generator.impactOccurred()
        isPresented.wrappedValue = false
    }
}
