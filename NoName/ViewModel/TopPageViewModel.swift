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
    @Published var stepData: Step = Step(step: 0, timeStamp: Date())
    @Published var users: [UserData] = []
    
    // 歩数の更新を行う
    func fetchAndSaveSteps(uid: String) async throws {
        var stepsInt: Int = 0
        
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
    
    
    func fetchUsers() async throws {
        let db = Firestore.firestore()
        let snapshot = try await db.collection(Collection.users).getDocuments()
        let documents = snapshot.documents
        
        let usersList = snapshot.documents.compactMap { document in
            let user = UserData.fromJson(json: document.data(), todayStep: nil)
            return user
        }
        
        var usertemp: [UserData] = []
        for user in usersList {
            // userを使用した処理
            let stepDocument = try await db.collection(Collection.users).document(user.id).collection(Collection.steps).document(Date().dateString()).getDocument()
            let step = stepDocument.data()?["steps"] as? Int
            usertemp.append(UserData(id: user.id, fullname: user.fullname, email: user.email, accountName: user.accountName, todayStep: step))
        }
        
        DispatchQueue.main.async {
            self.users = usertemp
        }
    }
}
