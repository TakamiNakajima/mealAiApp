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
    
    // デバイスから歩数を取得する
    func fetchSteps(uid: String) async throws -> Int {
        let steps = HKQuantityType.quantityType(forIdentifier: .stepCount)!
        let predicate = HKQuery.predicateForSamples(withStart: Calendar.current.startOfDay(for: Date()), end: Date())
        
        return try await withCheckedThrowingContinuation { continuation in
            let query = HKStatisticsQuery(quantityType: steps, quantitySamplePredicate: predicate) { _, result, error in
                guard let result = result, let quantity = result.sumQuantity(), error == nil else {
                    print("error fetching todays step data")
                    return
                }
                let stepCount = Int(quantity.doubleValue(for: HKUnit.count()))
                continuation.resume(returning: stepCount)
            }
            healthStore.execute(query)
        }
    }
    
    // 歩数を保存する
    func saveSteps(uid: String, steps: Int) async throws {
        let stepCollectionRef = Firestore.firestore().collection(Collection.users).document(uid).collection(Collection.steps)
        
        do {
            try await stepCollectionRef.document(Date().dateString()).setData([
                "steps": steps,
                "timeStamp": FieldValue.serverTimestamp()
            ], mergeFields:  ["steps", "timeStamp"])
        } catch {
            print("save steps error \(error)")
            throw error
        }
    }
    
    // サーバから歩数を取得する
    func loadingSteps(uid: String) async throws -> Step? {
        let stepCollectionRef = Firestore.firestore().collection(Collection.users).document(uid).collection(Collection.steps).document(Date().dateString())
        
        do {
            let documentSnapshot = try await stepCollectionRef.getDocument()
            if documentSnapshot.exists {
                if let data = documentSnapshot.data() {
                    if let stepData: Step = Step.fromJson(data) {
                        return stepData
                    } else {
                        print("Failed to convert Firestore data to Step type.")
                    }
                } else {
                    print("can't found data")
                }
            } else {
                print("can't found document")
            }
        } catch {
            print("Error: \(error.localizedDescription)")
        }
        return nil
    }
}

