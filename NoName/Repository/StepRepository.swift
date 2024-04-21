import Foundation
import HealthKit
import Firebase
import FirebaseFirestoreSwift

class StepRepository: ObservableObject {
    private let healthStore = HKHealthStore()
    private let quantityType = HKSampleType.quantityType(forIdentifier: .stepCount)!
    private let userCollectionRef: CollectionReference = Firestore.firestore().collection(Collection.users)
    
    // 初期処理
    init() {
        let steps = HKQuantityType(.stepCount)
        let healthTypes: Set = [steps]
        Task {
            do {
                try await healthStore.requestAuthorization(toShare: [], read: healthTypes)
            } catch {
                print("error in StepRepository.init()")
                throw error
            }
        }
    }
    
    // ヘルスケアから歩数を取得する
    func fetchSteps(uid: String, startDate: Date, endDate: Date) async throws -> Int {
        let periodPredicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate)
        let predicate = HKSamplePredicate.quantitySample(type: quantityType, predicate: periodPredicate)
        let descriptor = HKStatisticsQueryDescriptor(predicate: predicate, options: .cumulativeSum)
        let sum = try await descriptor.result(for: healthStore)?.sumQuantity()?.doubleValue(for: .count()) ?? 0
        
        return Int(sum)
    }
    
    // ヘルスケアの歩数をサーバへ保存する
    func saveSteps(uid: String, steps: Int, collection: String, documentName: String) async throws {
        let stepDocumentRef = userCollectionRef.document(uid).collection(collection).document(documentName)
        let saveData = StepData.toJson(step: steps, date: FieldValue.serverTimestamp())
        
        try await stepDocumentRef.setData(saveData, mergeFields:  ["steps", "timeStamp"])
    }
    
    // サーバから歩数を取得する
    func loadingSteps(uid: String, collection: String, documentName: String) async throws -> StepData? {
        let stepDocumentRef = userCollectionRef.document(uid).collection(collection).document(documentName)
        
        let documentSnapshot = try await stepDocumentRef.getDocument()
        guard let data = documentSnapshot.data() else {
            print("can't found Step data")
            return nil
        }
        let stepData = StepData.fromJson(data: data)
        
        return stepData
    }
}

