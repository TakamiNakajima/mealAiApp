
import SwiftUI

struct AddPage: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject var manager: StepRepository
    @EnvironmentObject var addPageViewModel: AddPageViewModel
    @State private var isPickerPresented = false
    @State private var image: UIImage?
    @State private var selectedType: Int = 0
    @State private var selectedDate = Date()
    @State private var inputKcal: Int = 0
    @State private var title: String = ""
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
                        .frame(height: 80)
                    DatePicker("日付を選択", selection: $selectedDate, displayedComponents: [.date, .hourAndMinute])
                        .datePickerStyle(WheelDatePickerStyle())
                        .labelsHidden()
                        .frame(width: 300, height: 60)
                        .environment(\.locale, Locale(identifier: "ja_JP"))
                    
                    Spacer()
                        .frame(height: 80)
                    
                    // タイトル
                    TextField("タイトル", value: $title, formatter: NumberFormatter())
                        .keyboardType(.numberPad)
                        .frame(width: 100)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .multilineTextAlignment(.center)
                        .submitLabel(.done)
                        .onChange(of: title) { newValue in
                            title = newValue
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
                    
                    
                    
                    
                    Spacer()
                        .frame(height: 80)
                    
                    HStack {
                        TextField("円", value: $inputKcal, formatter: NumberFormatter())
                            .keyboardType(.numberPad)
                            .frame(width: 100)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .multilineTextAlignment(.center)
                            .submitLabel(.done)
                            .onChange(of: inputKcal) { newValue in
                                inputKcal = newValue
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
                        .frame(height: 40)
                    
                    
                    MealImageLarge(type: $selectedType, userId: authViewModel.currentUser!.id, isPickerPresented: $isPickerPresented, image: $image)
                    
                    
                    Spacer()
                        .frame(height: 8)
                    
                    PrimaryButton(title: "保存", width: 240, height: 48) {
                        Task {
                            if (image != nil) {
                                await addPageViewModel.saveRecord(
                                    type: selectedType,
                                    title: title,
                                    image: image!,
                                    userId: authViewModel.currentUser!.id,
                                    date: selectedDate,
                                    price: inputKcal
                                )
                                selectedTab = BottomBarSelectedTab.home
                            } else {
                                print("画像がありません")
                            }
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
