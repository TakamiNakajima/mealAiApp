import Foundation
import HealthKit
import Firebase
import FirebaseFirestoreSwift

extension Date {
    static var startDay: Date {
        Calendar.current.startOfDay(for: Date())
    }
}

extension Double {
    func formattedString() -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.maximumFractionDigits = 0
        return numberFormatter.string(from: NSNumber(value:  self))!
    }
}

class StepRepository: ObservableObject {
    let healthStore = HKHealthStore()
    
    init() {
        let steps = HKQuantityType(.stepCount)
        let healthTypes: Set = [steps]
        Task {
            do {
                try await healthStore.requestAuthorization(toShare: [], read: healthTypes)
            } catch {
                print("error fetching health data")
            }
        }
    }
    
    // ヘルスケアから歩数を取得する
    func fetchTodaySteps(uid: String) async -> Double {
        let steps = HKQuantityType.quantityType(forIdentifier: .stepCount)!
        let startOfDay = Calendar.current.startOfDay(for: Date())
        let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: Date(), options: .strictStartDate)

        return await withCheckedContinuation { continuation in
            let query = HKStatisticsQuery(quantityType: steps, quantitySamplePredicate: predicate) { _, result, error in
                guard let result = result, let quantity = result.sumQuantity(), error == nil else {
                    print("error fetching todays step data")
                    continuation.resume(returning: 0.0)
                    return
                }
                let stepCount = quantity.doubleValue(for: HKUnit.count())
                continuation.resume(returning: stepCount)
            }
            healthStore.execute(query)
        }
    }
    
    // 歩数をDBに保存する
    func saveSteps(uid: String, steps: Double) async throws {
        let today = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateString = dateFormatter.string(from: today)
        let stepCollectionRef = Firestore.firestore().collection(Collection.users).document(uid).collection(Collection.steps)
        do {
            try await stepCollectionRef.document(dateString).setData([
                "steps": steps,
                "timeStamp": FieldValue.serverTimestamp()
            ], mergeFields:  ["steps", "timeStamp"])
            print("save steps success")
        } catch {
            print("save steps error \(error)")
            throw error
        }
    }
}
