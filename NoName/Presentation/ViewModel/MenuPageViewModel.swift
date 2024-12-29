import Foundation
import UIKit

@MainActor
class MenuPageViewModel: ObservableObject {
    @Published var thisMonthDays: [String] = []
    @Published var selectedYear: Int = 0
    @Published var selectedMonth: Int = 0
    @Published var selectedDay: Int = 0
    @Published var isLoading: Bool = false
    @Published var paymentRecordList: [Record] = []
    @Published var incomeRecordList: [Record] = []
    @Published var totalPayment: Int = 0
    @Published var goalKcal: Int = 1500
    let recordUseCase = RecordUseCase()
    
    // 画面表示の初期処理
    func initialize(uid: String) async {
        let today = Date()
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day], from: today)
        
        DispatchQueue.main.async {
            self.selectedYear = components.year ?? 0
            self.selectedMonth = components.month ?? 0
            self.selectedDay = components.day ?? 0
        }
        
        let dateStrings = getDateStringsInMonth(year: selectedYear, month: selectedMonth)
        DispatchQueue.main.async {
            self.thisMonthDays = dateStrings
        }
        // 食事記録取得
        await fetchRecords(userId: uid, isInitialize: true)
    }
    
    // 選択した日付を更新する
    func onTapCircle(day: Int, uid: String) {
        DispatchQueue.main.async {
            self.selectedDay = day
        }
    }
    
    // 今日の日付を取得する
    func getTodayDate() -> String {
        let calendar = Calendar.current
        let today = Date()
        
        // 今日の日にちを取得
        let day = calendar.component(.day, from: today)
        
        // 日を文字列に変換して返す
        return String(day)
    }
    
    // 指定月の日にちをリストて取得する
    private func getDateStringsInMonth(year: Int, month: Int) -> [String] {
        var dateStrings: [String] = []
        let calendar = Calendar.current
        
        // 指定された年と月の開始日を取得
        var components = DateComponents()
        components.year = year
        components.month = month
        components.day = 1
        
        // 月の最初の日を作成
        guard let startOfMonth = calendar.date(from: components) else { return dateStrings }
        
        // 月の日数を取得
        guard let range = calendar.range(of: .day, in: .month, for: startOfMonth) else { return dateStrings }
        
        // 日付フォーマッターの設定
        let formatter = DateFormatter()
        formatter.dateFormat = "d"
        
        // 各日付をリストに追加
        for day in range {
            components.day = day
            if let date = calendar.date(from: components) {
                let dateString = formatter.string(from: date)
                dateStrings.append(dateString)
            }
        }
        
        return dateStrings
    }
    
    // 記録取得処理
    func fetchRecords(userId: String, isInitialize: Bool) async {
        let recordRepository = RecordRepository()
        var records: [Record] = []
        var paymentRecords: [Record] = []
        self.paymentRecordList = []
        self.incomeRecordList = []
        let createDate = (isInitialize) ? Date() : createDateFromSelected()
        if (createDate == nil) { return }
        
        do {
            records = try await recordRepository.readRecord(date: createDate!, userId: userId)
            records.forEach { record in
                paymentRecords.append(record)
            }
            
            DispatchQueue.main.async {
                self.paymentRecordList = paymentRecords
            }
            
        } catch {
            print("Error uploading image: \(error)")
        }
        
        // 収支計算
        var payment = 0
        records.forEach { record in
            payment += record.price
        }
        DispatchQueue.main.async {
            self.totalPayment = payment
        }
    }
    
    func createDateFromSelected() -> Date? {
        let calendar = Calendar.current
        var components = DateComponents()
        components.year = selectedYear
        components.month = selectedMonth
        components.day = selectedDay
        
        return calendar.date(from: components)
    }
    
    // レコード削除
    func deleteRecord(recordId: String, userId: String) async {
        let _ = await recordUseCase.deleteRecord(recordId: recordId, userId: userId)
    }
}
