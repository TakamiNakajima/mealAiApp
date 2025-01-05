
import SwiftUI

struct AddPage: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject var addPageViewModel: AddPageViewModel
    @State private var selectedDate = Date()
    @State private var recipeTitle: String = ""
    @State private var description: String = ""
    @State private var cookingTime: Int = 0
    @State private var kcal: Int = 0
    @State private var selectedMealType: mealType = mealType.mainDish
    @Binding var selectedTab:BottomBarSelectedTab
    
    var body: some View {
        if let _ = authViewModel.currentUser {
            ZStack {
                
                Color.white
                    .ignoresSafeArea()
                    .onTapGesture {
                        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                    }
                
                VStack(spacing: 16) {
                    
                    Spacer()
                        .frame(height: 40)
                    
                    textInput(value: $recipeTitle, title: "タイトル")
                    
                    textInput(value: $description, title: "説明文")
                    
                    numberInput(value: $cookingTime, title: "調理時間", unit: "分")
                    
                    numberInput(value: $kcal, title: "カロリー", unit: "kcal")
                    
                    mealTypeInput(selectedMealType: $selectedMealType, options: mealType.allCases)
                                        
                    Spacer()
                        .frame(height: 8)
                    
                    PrimaryButton(title: "保存", width: 240, height: 48) {
                        Task {
                            await addPageViewModel.saveRecord(
                                title: recipeTitle,
                                userId: authViewModel.currentUser!.id,
                                selectedDate: selectedDate,
                                price: cookingTime
                            )
                            selectedTab = BottomBarSelectedTab.home
                        }
                    }
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

fileprivate struct textInput: View {
    @Binding var value: String
    var title: String
    
    var body: some View {
        HStack {
            Text(title)
            
            Spacer()
            
            TextField(title, text: $value)
                .padding(.horizontal, 8)
                .frame(width: 200, height: 44)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.gray, lineWidth: 1)
                )
                .multilineTextAlignment(.leading)
                .submitLabel(.done)
                .onChange(of: value) { newValue in
                    value = newValue
                    print(newValue)
                }
        }
        .padding(.horizontal, 24)

    }
}

fileprivate struct numberInput: View {
    @Binding var value: Int
    var title: String
    var unit: String
    
    var body: some View {
        HStack {
            Text(title)
            
            Spacer()
            
            HStack {
                TextField(title, value: $value, formatter: NumberFormatter())
                    .padding(.horizontal, 8)
                    .frame(width: 100, height: 44)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.gray, lineWidth: 1)
                    )
                    .multilineTextAlignment(.center)
                    .keyboardType(.numberPad)
                    .submitLabel(.done)
                    .onChange(of: value) { newValue in
                        value = newValue
                    }
                
                Text(unit)
            }
        }
        .padding(.horizontal, 24)
    }
}

fileprivate struct mealTypeInput: View {
    @Binding var selectedMealType: mealType
    var options: [mealType]

    var body: some View {
        HStack {
            Text("食事タイプ")
            
            Spacer()
            
            Picker(selection: $selectedMealType, label: Text("選択")) {
                ForEach(options, id: \.self) { option in
                    Text(option.displayName)
                        .tag(option)
                }
            }
            .pickerStyle(MenuPickerStyle())
        }
        .padding(.horizontal, 24)
    }
}
