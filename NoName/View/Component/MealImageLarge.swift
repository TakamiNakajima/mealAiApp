import SwiftUI

struct MealImageLarge: View {
    @Binding var type: Int
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
                    
                    Text(Texts.title(type: type))
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
}

