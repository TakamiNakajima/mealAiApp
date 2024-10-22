
import SwiftUI

struct AddPage: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject var manager: StepRepository
    @EnvironmentObject var addPageViewModel: AddPageViewModel
    @State private var isPickerPresented = false
    @State var image: UIImage?
    @State var type: Int?
    
    var body: some View {
        if let user = authViewModel.currentUser {
            VStack {
                Spacer()
                MealImageLarge(type: $type, userId: authViewModel.currentUser!.id, isPickerPresented: $isPickerPresented, image: $image)
                Spacer()
                Picker("Select a number", selection: $type) {
                    ForEach(0..<4) { number in
                        Text("\(title(type: number))").tag(number)
                    }
                }
                .pickerStyle(WheelPickerStyle())
                .frame(width: 100)
                Spacer()
                Button(action: {
                    Task {
                        if (image != nil) {
                            await addPageViewModel.saveMeal(type: type ?? 0, image: image!, userId: authViewModel.currentUser!.id)
                            
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
        }
    }
    
    private func title(type: Int) -> String {
        if (type == 0) {
            return "朝"
        } else if (type == 1) {
            return "昼"
        } else if (type == 2) {
            return "夜"
        } else {
            return "間食"
        }
    }
}

struct MealImageLarge: View {
    @Binding var type: Int?
    var userId: String
    @Binding var isPickerPresented: Bool
    @Binding var image: UIImage?
    
    var body: some View {
        if let image = image {
            // 画像が正常に取得できた場合
            Image(uiImage: image)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 240, height: 150)
                .cornerRadius(10)
        } else {
            Button(action: {
                isPickerPresented = true
            }) {
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.white)
                        .frame(width: 240, height: 150)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .strokeBorder(style: StrokeStyle(lineWidth: 1, dash: [5]))
                                .foregroundColor(.gray)
                        )
                    
                    Text(title(type: type ?? 0))
                        .font(.subheadline)
                        .padding(5)
                        .foregroundColor(.gray)
                }
            }
            .sheet(isPresented: $isPickerPresented) {
                PhotoPicker(selectedImage: $image)
            }
        }
    }
    
    private func title(type: Int) -> String {
        if (type == 0) {
            return "朝"
        } else if (type == 1) {
            return "昼"
        } else if (type == 2) {
            return "夜"
        } else {
            return "間食"
        }
    }
}

