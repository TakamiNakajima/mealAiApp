import SwiftUI

struct MealImage: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject var homePageViewModel: HomePageViewModel
    var type: Int
    var imageUrl: String?
    @Binding var isPickerPresented: Bool
    
    var body: some View {
        if let image = imageUrl {
            AsyncImage(url: URL(string: imageUrl!)) { phase in
                        switch phase {
                        case .empty:
                            // ローディング中の表示
                            ProgressView()
                                .frame(width: 160, height: 100)
                        case .success(let image):
                            // 正常に画像が読み込まれた場合
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 160, height: 100)
                                .cornerRadius(10)
                        case .failure:
                            // エラーが発生した場合の表示
                            Image(systemName: "photo")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 160, height: 100)
                                .foregroundColor(.gray)
                        @unknown default:
                            EmptyView()
                        }
                    }
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
                    
                    Text(Texts.title(type: type))
                        .font(.subheadline)
                        .padding(5)
                        .foregroundColor(.gray)
                }
            }
//            .sheet(isPresented: $isPickerPresented, onDismiss: {
//                            // シートが閉じられたときの処理
//                            if let selectedImage = imageUrl {
//                                print("Image selected, calling saveMeal")
//                                Task {
//                                    await homePageViewModel.saveMeal(type: type, image: selectedImage, userId: authViewModel.currentUser!.id)
//                                }
//                            }
//                        }) {
//                            PhotoPicker(selectedImage: $image)
//                        }
        }
    }
}

