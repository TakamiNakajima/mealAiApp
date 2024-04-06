//
//  ContentView.swift
//  SearchUser
//
//  Created by Takami Nakajima on 2024/04/05.
//

import SwiftUI

struct SearchUserPage: View {
    @State var inputText: String = ""
    @EnvironmentObject var viewModel: SearchUserViewModel
    
    var body: some View {
        VStack {
            Spacer()
                .frame(height: 50)
            TextField("アカウント名を入力", text: $inputText)
                .padding()
                .onSubmit {
                    if (inputText == "") {
                        print("アカウント名を入力してください")
                        return
                    }
                    
                    Task {
                        try await viewModel.searchUser(accountCode: inputText)
                    }
                }
            if (viewModel.foundUser != nil) {
                Text(viewModel.foundUser!.fullname)
                    .font(.largeTitle)
            }
            Spacer()
        }
        .padding()
    }
}
