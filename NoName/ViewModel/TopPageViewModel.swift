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
    @Published var dailyStepData: StepData?
    @Published var weeklyStepData: StepData?
    @Published var users: [UserData] = []
    
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
        
        // サーバから歩数取得
        do {
            let fetchdata = try await stepRepository.loadingSteps(uid: uid, collection: collection, documentName: startDate.dateString())
            if (collection == Collection.dailySteps) {
                DispatchQueue.main.async {
                    self.dailyStepData = fetchdata
                    print("Today's Steps：\(String(describing: self.dailyStepData))")

                }
            } else if (collection == Collection.weeklySteps) {
                DispatchQueue.main.async {
                    self.weeklyStepData = fetchdata
                    print("Weekly Steps：\(String(describing: self.weeklyStepData))")
                }
            }
        } catch {
            print("error loadingSteps()")
        }
    }
    
    // 全ユーザを取得する
    func fetchAllUsers(startDate: Date) async throws {
        let users = try await userRepository.getAllUsers()
        var userList: [UserData] = []
        
        for user in users {
            let dailyStepData = try await stepRepository.loadingSteps(uid: user.id, collection: Collection.dailySteps, documentName: Date().dateString())
            let weeklyStepData = try await stepRepository.loadingSteps(uid: user.id, collection: Collection.weeklySteps, documentName: startDate.dateString())
            userList.append(UserData(id: user.id, fullname: user.fullname, email: user.email, accountName: user.accountName, dailyStepData: dailyStepData, weeklyStepData: weeklyStepData))
        }
                
        userList.sort { (userData1, userData2) -> Bool in
            return userData1.weeklyStepData!.step > userData2.weeklyStepData!.step
        }
        
        DispatchQueue.main.async {
            self.users = userList
        }
    }
}
