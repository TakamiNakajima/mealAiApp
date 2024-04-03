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
    @Published var isButtonEnabled = true
    @Published var stepData: Step = Step(step: 0, timeStamp: Date())
    
    // 歩数の更新を行う
    func fetchAndSaveSteps(uid: String) async throws {
        var stepsInt: Int = 0
        
        // 更新ボタンを非活性
        self.isButtonEnabled = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 60) {
            self.isButtonEnabled = true
        }
        
        // 端末から取得
        do {
            stepsInt = try await stepRepository.fetchSteps(uid: uid)
        } catch {
            print("DEBUG: Failed to fetch Steps \(error.localizedDescription)")
        }
        
        // サーバへ保存
        if stepsInt != 0 {
            do {
                try await stepRepository.saveSteps(uid: uid, steps: stepsInt)
            } catch {
                print("DEBUG: Failed to save Steps \(error.localizedDescription)")
            }
        }
        
        // サーバから取得
        do {
            self.stepData = try await stepRepository.loadingSteps(uid: uid) ?? Step(step: 0, timeStamp: Date())
        } catch {
            print("error loadingSteps()")
        }
    }
}
