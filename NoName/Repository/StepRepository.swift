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

class StepRepository: ObservableObject {
    let healthStore = HKHealthStore()
    
    // 歩数を取得するための初期処理を行う
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
    
    // 歩数を取得する
    func fetchSteps(uid: String) async throws -> Int {
        let steps = HKQuantityType.quantityType(forIdentifier: .stepCount)!
        let predicate = HKQuery.predicateForSamples(withStart: Calendar.current.startOfDay(for: Date()), end: Date())
        var stepCount: Int = 0
        let semaphore = DispatchSemaphore(value: 0)
        
        let query = HKStatisticsQuery(quantityType: steps, quantitySamplePredicate: predicate) { _, result, error in
            guard let result = result, let quantity = result.sumQuantity(), error == nil else {
                print("error fetching todays step data")
                semaphore.signal()
                return
            }
            stepCount = Int(quantity.doubleValue(for: HKUnit.count()))
            semaphore.signal()
        }
        // HKStatisticsQuery を非同期的に実行
        healthStore.execute(query)
        
        // 完了ハンドラーの処理が完了するまで待機
        semaphore.wait()
        return stepCount
    }
    
    // 歩数を保存する
    func saveSteps(uid: String, steps: Int) async throws {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateString = dateFormatter.string(from: Date())
        let stepCollectionRef = Firestore.firestore().collection(Collection.users).document(uid).collection(Collection.steps)
        
        do {
            try await stepCollectionRef.document(dateString).setData([
                "steps": steps,
                "timeStamp": FieldValue.serverTimestamp()
            ], mergeFields:  ["steps", "timeStamp"])
        } catch {
            print("save steps error \(error)")
            throw error
        }
    }
}
