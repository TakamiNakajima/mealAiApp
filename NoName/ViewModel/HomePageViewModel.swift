import Foundation
import UIKit

@MainActor
class HomePageViewModel: ObservableObject {
    @Published var stepCount: Double = 0.0
    @Published var calories: Double = 0.0
    @Published var thisMonthDays: [String] = []
    @Published var selectedDate: String = ""
    @Published var isLoading: Bool = false
    @Published var morningMeal: Record?
    @Published var lunchMeal: Record?
    @Published var dinnerMeal: Record?
    @Published var breakMeal: Record?
    @Published var totalKcal: Int?
    @Published var goalKcal: Int? = 1500
    
    // 画面表示の初期処理
    func initialize(uid: String) async {
        let todayDate = getTodayDate()
        let dateStringsInSeptenber = getDateStringsInMonth(year: 2024, month: 10)
        DispatchQueue.main.async {
            self.selectedDate = todayDate
            self.thisMonthDays = dateStringsInSeptenber
            self.calories = self.calculateCalories(steps: Int(self.stepCount), weight: 60.0)
        }
        
        // 食事記録取得
        await fetchMeal(date: Date(), userId: uid)
    }
    
    // 選択した日付を更新する
    func onTapCircle(day: String) {
        DispatchQueue.main.async {
            self.selectedDate = day
        }
    }
    
    // 歩数から消費カロリーを計算する
    private func calculateCalories(steps: Int, weight: Double) -> Double {
        let mets = 3.5
        let speed = 4.8
        let strideLength = 0.75
        
        // 距離を計算 (km)
        let distance = Double(steps) * strideLength / 1000
        
        // 時間を計算 (時間)
        let time = distance / speed
        
        // 消費カロリーを計算
        let calories = mets * weight * time
        
        return calories
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
    
    // 食事記録取得処理
    func fetchMeal(date: Date, userId: String) async {
        let mealRepository = RecordRepository()
        var totalkcal = 0
        
        for i in 0...3 {
            do {
                let meal = try await mealRepository.fetchRecord(date: date, type: i, userId: userId)
                if (meal == nil) {return}
                totalkcal += meal!.price
                DispatchQueue.main.async {
                    if (meal!.type == 0) {
                        self.morningMeal = meal
                    } else if (meal!.type == 1) {
                        self.lunchMeal = meal
                    } else if (meal!.type == 2) {
                        self.dinnerMeal = meal
                    } else if (meal!.type == 3) {
                        self.breakMeal = meal
                    }
                }
            } catch {
                print("Error uploading image: \(error)")
            }
            
            DispatchQueue.main.async {
                self.totalKcal = totalkcal
            }
        }
    }
}
