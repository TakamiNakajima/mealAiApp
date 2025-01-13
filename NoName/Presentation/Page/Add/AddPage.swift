import SwiftUI
import PhotosUI

struct AddPage: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject var addPageViewModel: AddPageViewModel
    @Binding var selectedTab:BottomBarSelectedTab
    @State private var recipeTitle = ""
    @State private var recipeDescription = ""
    @State private var cookingTime = ""
    @State private var calories = ""
    @State private var selectedMealType: MealType = .mainDish
    @State private var tags = ""
    @State private var ingredients: [Ingredient] = []
    @State private var steps: [String] = []
    @State private var allergies: [String] = []
    @State private var selectedImage: UIImage?
    @State private var showImagePicker = false
    @State private var showPhotoPicker = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .center, spacing: 16) {
                    
                    ImagePickerView(showPhotoPicker: $showPhotoPicker, selectedImage: $selectedImage)
                    
                    MealTypePicker(selectedMealType: $selectedMealType)
                    
                    TextField("料理名を入力", text: $recipeTitle)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal)
                    
                    TextField("説明文を入力", text: $recipeDescription)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal)
                    
                    TextField("調理時間（分）を入力", text: $cookingTime)
                        .keyboardType(.numberPad)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal)
                    
                    TextField("カロリー（kcal）を入力", text: $calories)
                        .keyboardType(.numberPad)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal)
                    
                    // Tags Input
                    TextField("検索タグ（,区切り）", text: $tags)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal)
                    
                    // Ingredients Section
                    VStack(alignment: .leading) {
                        Text("材料リスト")
                            .font(.headline)
                        ForEach(ingredients.indices, id: \.self) { index in
                            IngredientView(
                                ingredient: $ingredients[index],
                                onDelete: {
                                    ingredients.remove(at: index)
                                }
                            )
                        }
                        Button(action: {
                            ingredients.append(Ingredient(name: "", quantity: 0, unit: .gram, saleArea: .vegetable))
                        }) {
                            Text("+ 材料を追加")
                                .foregroundColor(.blue)
                        }
                    }
                    .padding()
                    
                    VStack(alignment: .leading) {
                        Text("調理手順")
                            .font(.headline)
                        ForEach(steps.indices, id: \.self) { index in
                            HStack {
                                TextField("手順 \(index + 1)", text: $steps[index])
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                Button(action: {
                                    steps.remove(at: index)
                                }) {
                                    Image(systemName: "trash")
                                        .foregroundColor(.red)
                                }
                            }
                        }
                        Button(action: {
                            steps.append("")
                        }) {
                            Text("+ 手順を追加")
                                .foregroundColor(.blue)
                        }
                    }
                    .padding()
                    
                    VStack(alignment: .leading) {
                        Text("アレルギー")
                            .font(.headline)
                        WrapView(items: AllergyUtil.allergyList, selectedItems: $allergies)
                    }
                    
                    PrimaryButton(title: "保存", width: 240, height: 48) {
                        Task {
                            
                        }
                    }
                }
                .padding()
            }
        }
    }
}

fileprivate struct ImagePickerView: View {
    @Binding var showPhotoPicker: Bool
    @Binding var selectedImage: UIImage?
    
    var body: some View {
        HStack {
            Spacer()
            Button(action: {
                showPhotoPicker.toggle()
            }) {
                ZStack {
                    if let selectedImage = selectedImage {
                        Image(uiImage: selectedImage)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 140, height: 140)
                            .cornerRadius(8)
                    } else {
                        Text("画像を選択")
                            .frame(width: 140, height: 140)
                            .foregroundColor(.gray)
                            .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray, lineWidth: 1))
                    }
                }
            }
            .sheet(isPresented: $showPhotoPicker) {
                PhotoPicker(selectedImage: $selectedImage)
            }
            Spacer()
        }
        .padding()
    }
}

fileprivate struct MealTypePicker: View {
    @Binding var selectedMealType: MealType
    
    var body: some View {
        HStack(spacing: 4) {
            ForEach(MealType.allCases, id: \.self) { type in
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

fileprivate struct IngredientView: View {
    @Binding var ingredient: Ingredient
    var onDelete: () -> Void
    
    var body: some View {
        HStack {
            TextField("材料名", text: $ingredient.name)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .frame(width: 100)
            
            TextField("量", value: $ingredient.quantity, formatter: NumberFormatter())
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .frame(width: 50)
            
            Picker("単位", selection: $ingredient.unit) {
                ForEach(UnitType.allCases, id: \.self) { unit in
                    Text(unit.rawValue).tag(unit)
                }
            }
            .pickerStyle(MenuPickerStyle())
            .frame(width: 70)
            
            Picker("売り場", selection: $ingredient.saleArea) {
                ForEach(SaleArea.allCases, id: \.self) { area in
                    Text(area.rawValue).tag(area)
                }
            }
            .pickerStyle(MenuPickerStyle())
            .frame(width: 80)
            
            Button(action: onDelete) {
                Image(systemName: "trash")
                    .foregroundColor(.red)
            }
        }
    }
}

fileprivate struct WrapView: View {
    let items: [String]
    @Binding var selectedItems: [String]
    
    var body: some View {
        let columns = [GridItem(.adaptive(minimum: 100))]
        LazyVGrid(columns: columns, spacing: 8) {
            ForEach(items, id: \.self) { item in
                ChipView(item: item, isSelected: selectedItems.contains(item)) {
                    if selectedItems.contains(item) {
                        selectedItems.removeAll { $0 == item }
                    } else {
                        selectedItems.append(item)
                    }
                }
            }
        }
        .padding()
    }
}

fileprivate struct ChipView: View {
    let item: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Text(item)
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .foregroundColor(isSelected ? .white : Color("mainColorDark"))
            .frame(maxWidth: .infinity)
            .background(isSelected ? Color("mainColorDark") : Color.white)
            .cornerRadius(16)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color("mainColorDark"), lineWidth: 1)
            )
            .onTapGesture(perform: action)
    }
}
