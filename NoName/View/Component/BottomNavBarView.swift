import SwiftUI

// 現在選択中のボトムナビゲーションタブ
enum BottomBarSelectedTab:Int{
    case home = 0
    case workout = 1
    case add = 2
    case notification = 3
    case message = 4
}

// ボトムナビゲーションバー
struct BottomBar: View {
    
    @Environment(\.safeAreaInsets) var safeAreaInsets
    @Environment(\.colorScheme) var colorScheme
    @Binding var selectedTab:BottomBarSelectedTab
    
    var body: some View {
        HStack(spacing: 4){
            
            // ホーム
            Button {
                selectedTab = .home
            } label: {
                BottomBarButtonView(image: "house", text: "ホーム", isActive: selectedTab == .home)
            }
            
            // ワークアウト
            Button {
                selectedTab = .workout
            } label: {
                BottomBarButtonView(image: "movieclapper", text: "動画", isActive: selectedTab == .workout)
            }
            
            // 追加
            Button {
                selectedTab = .add
            } label: {
                VStack {
                    ZStack {
                        RoundedRectangle(cornerRadius: 30)
                            .frame(width: 60, height: 60)
                            .foregroundStyle(
                                LinearGradient(
                                    gradient: Gradient(colors: [.mint, .blue]),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .shadow(color: .gray.opacity(0.5), radius: 10, x: 0, y: 5)
                        Image(systemName: "plus")
                            .font(.title)
                            .foregroundColor(.white)
                    }
                    .padding(EdgeInsets(top: -23, leading: 0, bottom: 0, trailing: 0))
                    
                    Spacer()
                }
            }
            
            // お知らせ
            Button {
                selectedTab = .notification
            } label: {
                BottomBarButtonView(image: "bell", text: "お知らせ", isActive: selectedTab == .notification)
            }
            
            // メッセージ
            Button {
                selectedTab = .message
            } label: {
                BottomBarButtonView(image: "gearshape", text: "設定", isActive: selectedTab == .message)
            }
            
        }
        .frame(height: 40)
        .background(
            Image("bottomBarBG").renderingMode(.template).foregroundColor(Color("PrimaryWhite"))
        )
        .shadow(color: Color("PrimaryBlack").opacity(colorScheme == .dark ? 0.5 : 0.1), radius: 10, x: 0,y: 0)
        .padding(.horizontal, 8)
    }
}

struct BottomBarButtonView: View {
    
    var image:String
    var text:String
    var isActive:Bool
    
    var body: some View {
        HStack(spacing: 10){
            
            GeometryReader{
                geo in
                VStack(spacing: 3) {
                    
                    Rectangle()
                        .frame(height: 0)
                    
                    Image(systemName: image)
                        .foregroundColor(isActive ? .blue : .gray)
                    
                    Text(text)
                        .font(.caption)
                        .foregroundColor(isActive ? .blue : .gray)
                    
                }
            }
            
        }
    }
}
