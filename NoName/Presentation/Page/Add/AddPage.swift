import SwiftUI
import PhotosUI

struct AddPage: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject var addPageViewModel: AddPageViewModel
    @State private var price = ""
    @State private var selectedDate = Date()
    @State private var selectedPaymentType: PaymentType = .eatingOut
    @State private var isLoading: Bool = false
    @Binding var selectedTab: BottomBarSelectedTab
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
                            TypePicker(selectedMealType: $selectedPaymentType)
                            
                            Text("\(price)")
                                .font(.system(size: 32, weight: .bold))
                                .foregroundColor(Color("mainColorDark"))
                                .frame(height: 120)
                            
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
                                    await addPageViewModel.saveRecord(title: selectedPaymentType.displayName, userId: user.id, selectedDate: selectedDate, price: Int(price) ?? 0)
                                    isLoading = false
                                    selectedTab = .home
                                }
                            }
                        }
                        .padding()
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

fileprivate struct TypePicker: View {
    @Binding var selectedMealType: PaymentType
    
    var body: some View {
        HStack(spacing: 4) {
            ForEach(PaymentType.allCases, id: \.self) { type in
                Text(type.rawValue)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 6)
                    .foregroundColor(selectedMealType == type ? .white : Color.gray)
                    .background(selectedMealType == type ? Color("mainColorDark") : Color.gray.opacity(0.2))
                    .cornerRadius(20)
                    .frame(width: 80, height: 40)
                    .onTapGesture {
                        selectedMealType = type
                    }
            }
        }
        .padding()
    }
}
