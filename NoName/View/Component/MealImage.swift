import SwiftUI

struct MealImage: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject var homePageViewModel: HomePageViewModel
    var title: String
    @Binding var image: UIImage?
    @Binding var isPickerPresented: Bool
    
    var body: some View {
        if let image = image {
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
            .sheet(isPresented: $isPickerPresented, onDismiss: {
                            // シートが閉じられたときの処理
                            if let selectedImage = image {
                                print("Image selected, calling saveMeal")
                                Task {
                                    await homePageViewModel.saveMeal(type: 1, image: selectedImage, userId: authViewModel.currentUser!.id)
                                }
                            }
                        }) {
                            PhotoPicker(selectedImage: $image)
                        }
        }
    }
}

