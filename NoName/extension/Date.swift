//
//  Date.swift
//  NoName
//
//  Created by 中島昂海 on 2024/04/03.
//

import Foundation

extension Date {
    
    // 歩数保存(日)
    func dateString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateString = dateFormatter.string(from: self)
        return dateString
    }
    
    // 時間表示
    func displayDateString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        let dateString = dateFormatter.string(from: self)
        return dateString
    }
}
