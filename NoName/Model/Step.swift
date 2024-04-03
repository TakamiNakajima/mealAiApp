//
//  User.swift
//  NoName
//
//  Created by 中島昂海 on 2024/03/24.
//

import Foundation
import FirebaseFirestore

struct Step: Codable {
    let step: Int
    let timeStamp: Date
    
    static func fromJson(_ data: [String: Any]) -> Step? {
            guard let step = data["steps"] as? Int,
                  let timestamp = data["timeStamp"] as? Timestamp else {
                return nil
            }
            
        let date = timestamp.dateValue()
            return Step(step: step, timeStamp: date)
        }
}
