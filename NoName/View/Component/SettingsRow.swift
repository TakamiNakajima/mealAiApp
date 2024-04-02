//
//  SettingsRowView.swift
//  NoName
//
//  Created by 中島昂海 on 2024/03/24.
//

import SwiftUI

struct SettingsRow: View {
    let imageName: String
    let title: String
    let tintColor: Color
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: imageName)
                .imageScale(.small)
                .font(.title)
                .foregroundColor(tintColor)
            Text(title)
                .font(.subheadline)
                .foregroundColor(.black)
        }
    }
}

#Preview {
    SettingsRow(imageName: "gear", title: "Version", tintColor: Color(.systemGray))
}
