import SwiftUI

// 現在選択中のボトムナビゲーションタブ
enum BottomBarSelectedTab: Int {
    case home = 0
    case calendar = 1
    case add = 2
    case report = 3
    case setting = 4
    
    init?(from rawValue: Int) {
        self.init(rawValue: rawValue)
    }
}

// ボトムナビゲーションバー
struct BottomBar: View {
    let generator = UIImpactFeedbackGenerator(style: .light)
    @Environment(\.safeAreaInsets) var safeAreaInsets
    @Environment(\.colorScheme) var colorScheme
    @Binding var selectedTab:BottomBarSelectedTab
    
    var body: some View {
        HStack(spacing: 4){
            
            // ホーム
            Button {
                generator.impactOccurred()
                selectedTab = .home
            } label: {
                BottomBarButtonView(image: "house", text: "ホーム", isActive: selectedTab == .home)
            }
            
            // カレンダー
            Button {
                generator.impactOccurred()
                selectedTab = .calendar
            } label: {
                BottomBarButtonView(image: "calendar", text: "カレンダー", isActive: selectedTab == .calendar)
            }
            
            // 追加
            Button {
                generator.impactOccurred()
                selectedTab = .add
            } label: {
                VStack {
                    ZStack {
                        RoundedRectangle(cornerRadius: 30)
                            .frame(width: 60, height: 60)
                            .foregroundStyle(
                                LinearGradient(
                                    gradient: Gradient(colors: (selectedTab == .add) ? [.gray, .gray] : [Color("mainColorLight"), Color("mainColorDark")]),
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
            
            // レポート
            Button {
                generator.impactOccurred()
                selectedTab = .report
            } label: {
                BottomBarButtonView(image: "note.text", text: "レポート", isActive: selectedTab == .report)
            }
            
            // 設定
            Button {
                generator.impactOccurred()
                selectedTab = .setting
            } label: {
                BottomBarButtonView(image: "gearshape", text: "設定", isActive: selectedTab == .setting)
            }
            
        }
        .frame(height: 40)
        .background(
            Image("bottomBarBG").renderingMode(.template).foregroundColor(Color("PrimaryWhite"))
        )
        .shadow(color: .black.opacity(colorScheme == .dark ? 0.5 : 0.1), radius: 10, x: 0,y: 0)
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
                        .foregroundColor(isActive ? Color("mainColorDark") : .gray)
                        .frame(height: 20)
                    
                    Text(text)
                        .font(.caption)
                        .foregroundColor(isActive ? Color("mainColorDark") : .gray)
                }
            }
        }
    }
}
