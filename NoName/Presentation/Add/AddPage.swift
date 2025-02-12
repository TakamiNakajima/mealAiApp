import SwiftUI
import PhotosUI

struct AddPage: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject var addPageViewModel: AddPageViewModel
    @State private var price = ""
    @State private var selectedDate = Date()
    @State private var selectedPaymentType: PaymentType = .convinience
    @State private var isLoading: Bool = false
    @Binding var selectedTab: BottomBarSelectedTab
    @State private var isShowingDialog = false
    @State private var inputText = ""
    let generator = UIImpactFeedbackGenerator(style: .light)
    let numbers: [[String]] = [
        ["1", "2", "3"],
        ["4", "5", "6"],
        ["7", "8", "9"],
        ["0", "⌫"]
    ]
    
    var body: some View {
        if let user = authViewModel.currentUser {
            NavigationView {
                ZStack {
                    ScrollView {
                        VStack(alignment: .center, spacing: 16) {
                            
                            WrapView(selectedMealType: $selectedPaymentType, isShowingDialog: $isShowingDialog)
                            
                            HStack {
                                Spacer()
                                    .frame(width: 40, height: 60)
                                
                                Text("\(price)")
                                    .font(.system(size: 32, weight: .bold))
                                    .foregroundColor(Color("mainColorDark"))
                                    .frame(width: 120, height: 60)
                                
                                Text("円")
                                    .font(.system(size: 20, weight: .regular))
                                    .foregroundColor(Color("mainColorDark"))
                                    .frame(width: 40, height: 60)
                            }
                            
                            VStack(spacing: 12) {
                                ForEach(numbers, id: \.self) { row in
                                    HStack(spacing: 12) {
                                        ForEach(row, id: \.self) { number in
                                            Button(action: {
                                                generator.impactOccurred()
                                                handleNumberInput(number)
                                            }) {
                                                Text(number)
                                                    .font(.system(size: 16, weight: .regular))
                                                    .foregroundColor(Color.gray)
                                                    .frame(width: 64, height: 64)
                                                    .background(Color.gray.opacity(0.2))
                                                    .cornerRadius(32)
                                            }
                                        }
                                    }
                                }
                            }
                            .padding()
                            
                            PrimaryButton(title: "保存", width: 240, height: 48) {
                                generator.impactOccurred()
                                Task {
                                    isLoading = true
                                    await addPageViewModel.saveRecord(title: (selectedPaymentType == .selfInput) ? inputText : selectedPaymentType.displayName, userId: user.id, selectedDate: selectedDate, price: Int(price) ?? 0)
                                    isLoading = false
                                    selectedTab = .home
                                }
                            }
                        }
                        .padding()
                    }
                    .alert("入力してください", isPresented: $isShowingDialog) {
                        TextField("テキストを入力", text: $inputText)
                        Button("キャンセル", role: .cancel) {}
                        Button("OK") {
                            print("入力値: \(inputText)")
                        }
                    }
                    
                    if isLoading {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle())
                            .padding()
                    }
                }
            }
        }
    }
    
    private func handleNumberInput(_ number: String) {
        if number == "⌫" {
            if !price.isEmpty {
                price.removeLast()
            }
        } else {
            price.append(number)
        }
    }
}

fileprivate struct WrapView: View {
    @Binding var selectedMealType: PaymentType
    @Binding var isShowingDialog: Bool
    let generator = UIImpactFeedbackGenerator(style: .light)
    
    var body: some View {
        let columns = [GridItem(.adaptive(minimum: 100))]
        LazyVGrid(columns: columns, spacing: 8) {
            ForEach(PaymentType.allCases, id: \.self) { item in
                ChipView(item: item, isSelected: selectedMealType == item) {
                    generator.impactOccurred()
                    selectedMealType = item
                    if (selectedMealType == .selfInput) {
                        isShowingDialog = true
                    }
                }
            }
        }
        .padding()
    }
}

fileprivate struct ChipView: View {
    let item: PaymentType
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Text(item.displayName)
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .foregroundColor(isSelected ? .white : Color.gray.opacity(0.5))
            .frame(maxWidth: .infinity)
            .background(isSelected ? Color("mainColorDark") : Color.white)
            .cornerRadius(16)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(isSelected ? Color("mainColorDark") : Color.gray.opacity(0.5), lineWidth: 1)
            )
            .onTapGesture(perform: action)
    }
}
