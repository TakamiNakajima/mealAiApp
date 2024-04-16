//
//  Int.swift
//  NoName
//
//  Created by 中島昂海 on 2024/04/03.
//

import Foundation

extension Int {
    func formatString() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter.string(from: NSNumber(value: self)) ?? ""
    }
}
