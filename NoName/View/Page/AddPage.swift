
import SwiftUI

struct AddPage: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject var manager: StepRepository
    @EnvironmentObject var addPageViewModel: AddPageViewModel
    @State private var isPickerPresented = false
    @State private var image: UIImage?
    @State private var type: Int?
    @State private var selectedDate = Date()
    @State private var inputNumber: Int = 0
    
    var body: some View {
        if let user = authViewModel.currentUser {
            ZStack {
                VStack(spacing: 32) {
                    
                    Picker("Select a number", selection: $type) {
                        ForEach(0..<4) { number in
                            Text("\(Texts.title(type: number))").tag(Optional(number))
                        }
                    }
                    .pickerStyle(WheelPickerStyle())
                    .frame(width: 100, height: 160)
                    
                    MealImageLarge(type: $type, userId: authViewModel.currentUser!.id, isPickerPresented: $isPickerPresented, image: $image)
                    
                    DatePicker("日付を選択", selection: $selectedDate, displayedComponents: [.date, .hourAndMinute])
                        .datePickerStyle(WheelDatePickerStyle())
                        .labelsHidden()
                        .frame(width: 300, height: 100)
                        .environment(\.locale, Locale(identifier: "ja_JP"))
                                        
                    TextField("カロリー", value: $inputNumber, formatter: NumberFormatter())
                        .keyboardType(.numberPad)
                        .padding()
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .multilineTextAlignment(.center)
                                        
                    Button(action: {
                        Task {
                            if (image != nil) {
                                await addPageViewModel.saveMeal(type: type ?? 0, image: image!, userId: authViewModel.currentUser!.id, date: selectedDate, kcal: inputNumber)
                                
                            }
                        }
                    }) {
                        Text("保存")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .background(.blue)
                            .cornerRadius(10)
                    }
                    
                    Spacer()
                    
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                
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
