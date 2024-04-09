//
//  Card.swift
//  NoName
//
//  Created by 中島昂海 on 2024/04/09.
//

import SwiftUI
struct Card: View {
    var user: UserData
    
    var body: some View {
        HStack {
            VStack {
                VStack(alignment: .center) {
                    Spacer()
                        .frame(height: 8)
                    Text("Ranking")
                        .font(.footnote)
                        .foregroundColor(Color.customThemeColor)
                    Text("1")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(Color.customThemeColor)
                }
            }
            
            Spacer()
                .frame(width: 16)
            
            VStack {
                Spacer()
                HStack {
                    
                    VStack {
                        // 画像
                        Circle()
                            .frame(width: 48, height: 48)
                            .foregroundColor(Color.customThemeColor)
                    }
                    
                    Spacer()
                        .frame(width: 16)
                    
                    VStack(alignment: .leading) {
                        // 名前
                        Text(user.fullname)
                            .fontWeight(.bold)
                            .foregroundColor(Color.customThemeColor)
                        // アカウント名
                        Text(("@\(user.accountName)"))
                            .font(.footnote)
                            .fontWeight(.light)
                            .foregroundColor(.gray)
                    }
                    
                    Spacer()

                    VStack() {
                        Text(user.todayStep?.formattedString() ?? "--")
                            .font(.title3)
                            .foregroundColor(Color.customThemeColor)
                            .fontWeight(.bold)
                        Text("(12:05時点)")
                            .font(.footnote)
                            .foregroundColor(.gray)
                    }
                }
                .padding(12)
                .background(.white)
                .cornerRadius(16)
                .clipped()
                .shadow(color: .gray.opacity(0.7), radius: 5)
            }
            .frame(height: 72)
        }
        .padding(.horizontal, 16)
    }
}
