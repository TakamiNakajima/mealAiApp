//
//  User.swift
//  NoName
//
//  Created by 中島昂海 on 2024/03/24.
//

import Foundation

struct User: Identifiable, Codable {
    let id: String
    let fullname: String
    let email: String
    let accountName: String
    
    var initials: String {
        let formatter = PersonNameComponentsFormatter()
        if let components = formatter.personNameComponents(from: fullname) {
            formatter.style = .abbreviated
            return formatter.string(from: components)
        }
        return ""
    }
    
    static func fromJson(json: [String: Any]) -> User? {
        guard
            let id = json["id"] as? String,
            let fullname = json["fullname"] as? String,
            let email = json["email"] as? String,
            let accountName = json["accountName"] as? String
        else {
            return nil
        }
        
        return User(id: id, fullname: fullname, email: email, accountName: accountName)
    }
}
