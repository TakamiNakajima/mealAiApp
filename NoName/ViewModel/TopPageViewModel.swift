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
class TopPageViewModel: ObservableObject {
    let stepRepository = StepRepository()
    @Published var steps: String = "--"
        
    // 歩数の取得と保存を行う
    func fetchAndSaveSteps(uid: String) async throws {
        var stepsInt: Int = 0
        
        // 取得
        do {
            stepsInt = try await stepRepository.fetchSteps(uid: uid)
            steps = String(stepsInt)
        } catch {
            print("DEBUG: Failed to fetch Steps \(error.localizedDescription)")
        }
        
        // 保存
        if stepsInt != 0 {
            do {
                try await stepRepository.saveSteps(uid: uid, steps: stepsInt)
            } catch {
                print("DEBUG: Failed to save Steps \(error.localizedDescription)")
            }
        }
    }
}
