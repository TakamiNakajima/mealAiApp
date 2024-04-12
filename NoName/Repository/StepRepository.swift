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
    
    // 初期処理
    init() {
        let steps = HKQuantityType(.stepCount)
        let healthTypes: Set = [steps]
        Task {
            do {
                try await healthStore.requestAuthorization(toShare: [], read: healthTypes)
            } catch {
                print("error StepRepository.init()")
                throw error
            }
        }
    }
    
    // ヘルスケアアプリから歩数を取得する
    func fetchSteps(uid: String, startDate: Date, endDate: Date) async throws -> Int {
        let steps = HKQuantityType.quantityType(forIdentifier: .stepCount)!
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate)
        
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
    
    // 歩数をサーバへ保存する
    func saveSteps(uid: String, steps: Int, collection: String, date: Date?) async throws {
        let stepCollectionRef = Firestore.firestore().collection(Collection.users).document(uid).collection(collection)
        let saveData = StepData.toJson(step: steps, date: FieldValue.serverTimestamp())
        let day = date ?? Date()
        
        do {
            try await stepCollectionRef.document(day.dateString()).setData(saveData, mergeFields:  ["steps", "timeStamp"])
        } catch {
            print("error StepRepository.saveSteps()")
            throw error
        }
    }
    
    // サーバから歩数を取得する
    func loadingSteps(uid: String, collection: String, date: Date) async throws -> StepData? {
        let stepCollectionRef = Firestore.firestore().collection(Collection.users).document(uid).collection(collection).document(date.dateString())
        
        do {
            let documentSnapshot = try await stepCollectionRef.getDocument()
            if !documentSnapshot.exists {
                print("can't found document")
                return nil
            }
            
            guard let data = documentSnapshot.data() else {
                print("can't found documentSnapshot.data()")
                return nil
            }
            
            guard let stepData = StepData.fromJson(data: data) else {
                print("Failed to convert StepData")
                return nil
            }
            
            return stepData
        } catch {
            print("Error: \(error.localizedDescription)")
            return nil
        }
    }
}

