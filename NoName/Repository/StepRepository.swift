//
//  HealthRepository.swift
//  NoName
//
//  Created by 中島昂海 on 2024/03/31.
//

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
    @Published var stepCount: String = "--"
    
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
    
    // ヘルスケアから歩数を取得してDBに保存する
    func fetchTodaySteps(uid: String) async {
        let steps = HKQuantityType(.stepCount)
        let predicate = HKQuery.predicateForSamples(withStart: .startDay, end: Date())
        let query = HKStatisticsQuery(quantityType: steps, quantitySamplePredicate: predicate) { _, result, error in
            guard let result = result, let quantity = result.sumQuantity(), error == nil else {
                print("error fetching todays step data")
                return
            }
            let stepCount = quantity.doubleValue(for: .count())
            DispatchQueue.main.async {
                self.stepCount = stepCount.formattedString()
            }
        }
        if stepCount != "--" {
            do {
                try await saveSteps(uid: uid, steps: self.stepCount)
            } catch {
                print("歩数保存失敗")
            }
        }
        healthStore.execute(query)
    }
    
    // 歩数をDBに保存する
    func saveSteps(uid: String, steps: String) async throws {
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
