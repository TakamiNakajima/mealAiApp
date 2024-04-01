//
//  AuthViewModel.swift
//  NoName
//
//  Created by 中島昂海 on 2024/03/24.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

@MainActor
class ProfileViewModel: ObservableObject {
    @Published var stepCount: String = "--"

    init() {
        let manager = HealthManager()
        manager.fetchTodaySteps()
    }
    
    func saveSteps(uid: String, steps: Int) async throws {
        let today = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateString = dateFormatter.string(from: today)
        let stepCollectionRef = Firestore.firestore().collection("users").document(uid).collection("steps")
        do {
            stepCollectionRef.document(dateString).setData([
                "steps": steps,
                "timeStamp": FieldValue.serverTimestamp()
            ], mergeFields:  ["steps", "timeStamp"]) { error in 
                if let error = error {
                print("歩数保存error")
            } else {
                print("歩数保存success")
            }
                
            }
            
        } catch {
            print("DEBUG: Failed to create user with error \(error.localizedDescription)")
        }
    }

}
