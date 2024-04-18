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
    private let stepRepository = StepRepository()
    private let userRepository = UserRepository()
    @Published var users: [UserData] = []
    @Published var remaining: TimeInterval = 60
    
    // 歩数の更新を行う
    func updateSteps(uid: String, startDate: Date, endDate: Date, collection: String) async throws {
        var stepsInt: Int?
        
        // ヘルスケアから歩数取得
        do {
            stepsInt = try await stepRepository.fetchSteps(uid: uid, startDate: startDate, endDate: endDate)
        } catch {
            print("DEBUG: Failed to fetch Steps \(error.localizedDescription)")
        }
        
        // サーバへ歩数保存
        do {
            try await stepRepository.saveSteps(uid: uid, steps: stepsInt!, collection: collection, documentName: startDate.dateString())
        } catch {
            print("DEBUG: Failed to save Steps \(error.localizedDescription)")
        }
    }
    
    func countdownTimer() {
        if let remainingTime = remainingTimeUntilNextSunday21() {
            self.remaining = remainingTime
            // 1秒ごとにカウントダウンを更新するタイマーを開始
            let timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
                DispatchQueue.main.async {
                    self.remaining -= 1
                }
            }
            // タイマーをメインループに追加して実行
            RunLoop.main.add(timer, forMode: .common)
        }
    }

    // 全ユーザを取得する
    func fetchAllUsers(startDate: Date) async throws {
        
        let querySnapshot: QuerySnapshot
        var users: [UserData] = []
        do {
            querySnapshot = try await userRepository.getAllUsers()
        } catch {
            print("error: ")
            throw error
        }
        
        users = querySnapshot.documents.compactMap { document in
            return UserData.fromJson(json: document.data(), dailyStepData: nil, weeklyStepData: nil)
        }
        
        if (users.isEmpty) {
            print("users.isEmpty")
            return
        }

        var userList: [UserData] = []
        for user in users {
            var dailyStepData: StepData? = StepData(step: 0, timeStamp: Date())
            var weeklyStepData: StepData? = StepData(step: 0, timeStamp: Date())
            do {
                dailyStepData = try await stepRepository.loadingSteps(uid: user.id, collection: Collection.dailySteps, documentName: Date().dateString()) ?? nil
            } catch {
                print("error in TopPageViewModel.fetchAllUsers(): dailyStepData")
            }
            
            do {
                weeklyStepData = try await stepRepository.loadingSteps(uid: user.id, collection: Collection.weeklySteps, documentName: startDate.dateString()) ?? nil
            } catch {
                print("error in TopPageViewModel.fetchAllUsers(): weeklyStepData")
            }
        
            let userData = UserData(id: user.id, fullname: user.fullname, email: user.email, accountName: user.accountName, dailyStepData: dailyStepData, weeklyStepData: weeklyStepData)
            userList.append(userData)
        }
        
        userList.sort { (userData1, userData2) -> Bool in
            let step1 = userData1.weeklyStepData?.step ?? 0
            let step2 = userData2.weeklyStepData?.step ?? 0
            return step1 > step2
        }
        
        DispatchQueue.main.async {
            self.users = userList
        }
    }
}
