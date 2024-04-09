//
//  RectangleItem.swift
//  NoName
//
//  Created by 中島昂海 on 2024/04/07.
//

import SwiftUI

struct rectangleItem: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    let user: UserData
    
    var body: some View {
        HStack(spacing: 12) {
            RoundedRectangle(cornerRadius: 20)
                .fill(user.id == authViewModel.currentUser?.id ? Color.customThemeColor : Color.white)
                .frame(height: 70)
                .shadow(radius: 5)
                .overlay(
                    HStack {
                        Text(user.initials)
                            .font(.title)
                            .fontWeight(.semibold)
                            .foregroundColor(user.id == authViewModel.currentUser?.id ? Color.customThemeColor : Color.customSubColor)
                            .frame(width: 48, height: 48)
                            .background(Color(.systemGray3))
                            .clipShape(Circle())
                        VStack(alignment: .leading) {
                            Text(user.fullname)
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .padding(.top, 4)
                                .foregroundColor(user.id == authViewModel.currentUser?.id ? Color.white : Color.customThemeColor)
                            Text("@\(user.accountName)")
                                .font(.footnote)
                                .foregroundColor(user.id == authViewModel.currentUser?.id ? Color.white : Color.customThemeColor)
                        }
                        Spacer()
                        VStack {
                            Text(user.todayStep?.formattedString() ?? "--")
                                .font(.system(size: 20))
                                .fontWeight(.bold)
                                .foregroundColor(user.id == authViewModel.currentUser?.id ? Color.white : Color.customThemeColor)
                        }
                    }
                    .padding()
                )
                .padding(.horizontal, 40)
                .padding(.vertical, 4)
        }
    }
}
