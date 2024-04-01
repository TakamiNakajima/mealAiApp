//
//  HealthRepository.swift
//  NoName
//
//  Created by 中島昂海 on 2024/03/31.
//

import Foundation
import HealthKit

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

class HealthManager: ObservableObject {
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
    
    func fetchTodaySteps() {
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
        healthStore.execute(query)
    }
}
