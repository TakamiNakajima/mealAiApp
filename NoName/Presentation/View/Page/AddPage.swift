
import SwiftUI

struct AddPage: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject var addPageViewModel: AddPageViewModel
    @State private var isPickerPresented = false
    @State private var image: UIImage?
    @State private var selectedType: Int = 0
    @State private var selectedDate = Date()
    @State private var inputPrice: Int = 0
    @State private var recordTitle: String = ""
    @Binding var selectedTab:BottomBarSelectedTab
    
    var body: some View {
        if let _ = authViewModel.currentUser {
            ZStack {
                VStack(spacing: 16) {
                    
                    HStack() {
                        ToggleButton(selectedType: $selectedType, value: 0)
                        ToggleButton(selectedType: $selectedType, value: 1)
                    }
                    .padding()
                    
                    Spacer()
                        .frame(height: 40)
                    DatePicker("日付を選択", selection: $selectedDate, displayedComponents: [.date, .hourAndMinute])
                        .datePickerStyle(WheelDatePickerStyle())
                        .labelsHidden()
                        .frame(width: 300, height: 60)
                        .environment(\.locale, Locale(identifier: "ja_JP"))
                    
                    Spacer()
                        .frame(height: 40)
                    
                    // タイトル
                    TextField("タイトル", text: $recordTitle)
                        .frame(width: 200, height: 80)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .multilineTextAlignment(.center)
                        .submitLabel(.done)
                        .onChange(of: recordTitle) { newValue in
                            recordTitle = newValue
                            print(newValue)
                        }
                        .onSubmit {
                            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                        }
                    
                    HStack {
                        TextField("円", value: $inputPrice, formatter: NumberFormatter())
                            .keyboardType(.numberPad)
                            .frame(width: 100)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .multilineTextAlignment(.center)
                            .submitLabel(.done)
                            .onChange(of: inputPrice) { newValue in
                                inputPrice = newValue
                                print(inputPrice)
                            }
                            .onSubmit {
                                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                            }
                            .toolbar {
                                ToolbarItemGroup(placement: .keyboard) {
                                    Spacer()
                                    Button("完了") {
                                        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                                    }
                                }
                            }
                        
                        Text("円")
                        
                    }
                                        
                    Spacer()
                        .frame(height: 8)
                    
                    PrimaryButton(title: "保存", width: 240, height: 48) {
                        print("title: \(recordTitle)")
                        Task {
                            let dateFormatter = DateFormatter()
                            dateFormatter.dateFormat = "yyyy-MM-dd"
                            let dateString = dateFormatter.string(from: selectedDate)
                            await addPageViewModel.saveRecord(
                                type: selectedType,
                                title: recordTitle,
                                userId: authViewModel.currentUser!.id,
                                date: dateString,
                                price: inputPrice
                            )
                            selectedTab = BottomBarSelectedTab.home
                        }
                    }
                    
                    Spacer()
                    
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .onTapGesture {
                    // キーボードを閉じる
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                }
                
                if addPageViewModel.isLoading {
                    ZStack {
                        Color.white.opacity(0.6)
                            .ignoresSafeArea()
                        ProgressView("Loading...")
                            .progressViewStyle(CircularProgressViewStyle())
                            .padding()
                    }
                    
                }
            }
        }
    }
}

// トグルボタン
struct ToggleButton: View {
    @Binding var selectedType: Int
    var value: Int
    
    var body: some View {
        Button(action: {
            selectedType = value
        }) {
            Text(Texts.title(type: value))
                .frame(width: 80, height: 40)
                .font(.subheadline)
                .background(selectedType == value
                            ? LinearGradient(
                                gradient: Gradient(colors: [.mint, .blue]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ) : LinearGradient(
                                gradient: Gradient(colors: [.gray, .gray]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ))
                .foregroundColor(.white)
                .cornerRadius(24)
        }
    }
}
