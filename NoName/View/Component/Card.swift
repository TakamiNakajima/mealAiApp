//
//  Card.swift
//  NoName
//
//  Created by 中島昂海 on 2024/04/09.
//

import SwiftUI
struct Card: View {
    var user: UserData
    var ranking: Int
    
    var body: some View {
        let isFirst = (self.ranking == 1)
        HStack {
            VStack(alignment: .center) {
                
                Spacer()
                    .frame(height: 4)
                
                Text(String(ranking))
                    .font((isFirst) ? .largeTitle : .title)
                    .fontWeight(.bold)
                    .foregroundColor((isFirst) ? Color.customAccentColor : Color.customThemeColor)
                
            }
            .padding(.horizontal, 8)
            
            Spacer()
                .frame(width: 16)
            
            VStack {
                Spacer()
                HStack {
                    
                    VStack {
                        // 画像
                        Circle()
                            .frame(width: (isFirst) ? 44 : 40, height: (isFirst) ? 44 : 40)
                            .foregroundColor(Color.customSubColor)
                    }
                    
                    Spacer()
                        .frame(width: 8)
                    
                    VStack(alignment: .leading) {
                        
                        Text(user.fullname)
                            .font(.system(size: (isFirst) ? 14 : 12))
                            .fontWeight(.bold)
                            .foregroundColor((isFirst) ? .white : Color.customThemeColor)
                        
                        Text(("@\(user.accountName)"))
                            .font(.system(size: (isFirst) ? 11 : 9))
                            .fontWeight(.light)
                            .foregroundColor((isFirst) ? .white : Color.customThemeColor)
                    }
                    
                    Spacer()
                    
                    VStack() {
                        HStack(alignment: .bottom, spacing: 1) {
                            
                            Text(user.weeklyStepData?.step.formatString() ?? "--")
                                .font(.system(size: (isFirst) ? 22 : 20))
                                .foregroundColor((isFirst) ? .white : Color.customThemeColor)
                                .fontWeight(.bold)
                            
                            VStack {
                                Text("Stps")
                                    .font(.system(size: (isFirst) ? 10 : 9))
                                    .foregroundColor((isFirst) ? .white : Color.customThemeColor)
                                    .fontWeight(.regular)
                                
                                Spacer()
                                    .frame(height: 2)
                                
                            }
                        }
                        if (user.weeklyStepData != nil) {
                            Text("(\(user.weeklyStepData!.timeStamp.displayDateString())時点)")
                                .font(.system(size: (isFirst) ? 10 : 9))
                                .foregroundColor((isFirst) ? .white : Color.customThemeColor)
                        }
                    }
                }
                .padding(12)
                .background((isFirst) ? Color.customAccentColor : .white)
                .cornerRadius(16)
                .clipped()
                .shadow(color: .gray.opacity(0.7), radius: 5)
            }
            .frame(height: 72)
        }
        .padding(.horizontal, (isFirst) ? 24 : 36)
    }
}
