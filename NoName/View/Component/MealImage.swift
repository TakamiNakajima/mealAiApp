import SwiftUI

struct MealImage: View {
    var title: String
    @Binding var morningImage: UIImage?
    @Binding var isPickerPresented: Bool
    
    var body: some View {
        if let image = morningImage {
            Image(uiImage: image)
                .resizable()
                .frame(width: 160, height: 100)
                .cornerRadius(12)
        } else {
            Button(action: {
                isPickerPresented = true
            }) {
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.white)
                        .frame(width: 160, height: 100)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .strokeBorder(style: StrokeStyle(lineWidth: 1, dash: [5]))
                                .foregroundColor(.gray)
                        )
                    
                    Text(title)
                        .font(.subheadline)
                        .padding(5)
                        .foregroundColor(.gray)
                }
            }
            .sheet(isPresented: $isPickerPresented) {
                PhotoPicker(selectedImage: $morningImage)
            }
        }
    }
}

