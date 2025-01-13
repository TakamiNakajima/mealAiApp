import SwiftUI

struct MealImage: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject var homePageViewModel: MenuListPageViewModel
    @Binding var selectedTab:BottomBarSelectedTab
    var type: Int
    var imageUrl: String?
    
    var body: some View {
        if let _ = imageUrl {
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
                selectedTab = BottomBarSelectedTab.add
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
                    
                    Text(TextUtil.title(type: type))
                        .font(.subheadline)
                        .padding(5)
                        .foregroundColor(.gray)
                }
            }
        }
    }
}

