import SwiftUI

enum GeneratePageState {
    case first
    case second
    case third
}

struct GenerateMenuPage: View {
    @EnvironmentObject var viewModel: GenerateMenuViewModel
    @Binding var isPresented: Bool
    @State private var dates: Set<DateComponents> = []
    @State private var startDate: Date? = nil
    @State private var endDate: Date? = nil
    @State private var pageState: GeneratePageState = .first
    
    var body: some View {
        VStack(spacing: 20) {
            
            switch pageState {
            case .first:
                Text("開始日を選択してください")
                    .font(.headline)
            case .second:
                Text("終了日を選択してください")
                    .font(.headline)
            case .third:
                Text("献立を作成しています...")
                    .font(.headline)
            }
            
            switch pageState {
            case .first, .second:
                MultiDatePicker("複数の日付選択", selection: $dates)
                    .frame(width: 300, height: 300)
                    .environment(\.locale, Locale(identifier: "ja"))
                    .tint(Color("mainColorLight"))
                    .onChange(of: dates) { newDates in
                        viewModel.onSelectDate(
                            dates: dates,
                            startDate: $startDate,
                            endDate: $endDate,
                            pageState: $pageState
                        )
                    }
            case .third:
                if let startDate = startDate, let endDate = endDate {
                    HStack(spacing: 0) {
                        Text("\(viewModel.formattedDate(from: startDate)) 〜 ")
                        Text("\(viewModel.formattedDate(from: endDate))")
                    }
                }
            }
            
            Button {
                viewModel.onTapBackButton(isPresented: $isPresented)
            } label: {
                Text("戻る")
                    .padding()
                    .background(Color("mainColorLight"))
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
        }
        .padding()
    }
}
