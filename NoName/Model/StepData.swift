//
//  User.swift
//  NoName
//
//  Created by 中島昂海 on 2024/03/24.
//

import Foundation
import FirebaseFirestore

struct StepData: Codable {
    let step: Int
    let timeStamp: Date
    
    static func fromJson(data: [String: Any]) -> StepData? {
        guard let step = data["steps"] as? Int,
              let timestamp = data["timeStamp"] as? Timestamp else {
            return nil
        }
        
        let date = timestamp.dateValue()
        return StepData(step: step, timeStamp: date)
    }
    
    static func toJson(step: Int, date: FieldValue) -> [String : Any] {
        let stapData = [
            "steps": step,
            "timeStamp": date
        ] as [String : Any]
        return stapData
    }
}
