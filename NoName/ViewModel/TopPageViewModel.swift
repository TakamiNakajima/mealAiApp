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
    let userRepository = UserRepository()
    @Published var dailyStepData: StepData = StepData(step: 0, timeStamp: Date())
    @Published var weeklyStepData: StepData = StepData(step: 0, timeStamp: Date())
    @Published var users: [UserData] = []
    
    // 歩数の更新を行う
    func updateSteps(uid: String, startDate: Date, endDate: Date, collection: String) async throws {
        var stepsInt: Int = 0
        
        // ヘルスケアから取得
        do {
            stepsInt = try await stepRepository.fetchSteps(uid: uid, startDate: startDate, endDate: endDate)
        } catch {
            print("DEBUG: Failed to fetch Steps \(error.localizedDescription)")
        }
        
        // サーバへ保存
        if stepsInt != 0 {
            do {
                try await stepRepository.saveSteps(uid: uid, steps: stepsInt, collection: collection, date: startDate)
            } catch {
                print("DEBUG: Failed to save Steps \(error.localizedDescription)")
            }
        }
        
        // サーバから取得
        do {
            if (collection == Collection.dailySteps) {
                self.dailyStepData = try await stepRepository.loadingSteps(uid: uid, collection: collection, date: startDate) ?? StepData(step: 0, timeStamp: Date())
            } else if (collection == Collection.weeklySteps){
                self.weeklyStepData = try await stepRepository.loadingSteps(uid: uid, collection: collection, date: startDate) ?? StepData(step: 0, timeStamp: Date())
            }
        } catch {
            print("error loadingSteps()")
        }
    }
    
    // 全ユーザを取得する
    func fetchUsers(startDate: Date) async throws {
        
        let users = try await userRepository.getUsers()
        
        var userList: [UserData] = []
        for user in users {
            let dailyStepData = try await stepRepository.loadingSteps(uid: user.id, collection: Collection.dailySteps, date: Date())
            let weeklyStepData = try await stepRepository.loadingSteps(uid: user.id, collection: Collection.weeklySteps, date: startDate)
            userList.append(UserData(id: user.id, fullname: user.fullname, email: user.email, accountName: user.accountName, dailyStepData: dailyStepData, weeklyStepData: weeklyStepData))
        }
        
        DispatchQueue.main.async {
            self.users = userList
        }
    }
}
