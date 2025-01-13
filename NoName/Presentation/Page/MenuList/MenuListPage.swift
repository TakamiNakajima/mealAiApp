
import SwiftUI

// 献立表画面
struct MenuListPage: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject var viewModel: MenuListPageViewModel
    @State private var showDeleteConfirmation = false
    @Binding var selectedTab:BottomBarSelectedTab
    @State private var selectedRecordId: String?
    
    var body: some View {
        if let user = authViewModel.currentUser {
            ZStack {
                VStack(spacing: 20) {
                    
                    // AppBar
                    VStack {
                        Text("\(String(viewModel.selectedYear))年\(viewModel.selectedMonth)月")
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundColor(Color.blue)
                        
                        ScrollViewReader { proxy in
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack {
                                    ForEach(viewModel.thisMonthDays, id: \.self) { day in
                                        if day == String(viewModel.selectedDay) {
                                            CircleText(number: day)
                                        } else {
                                            DashedCircleText(number: day) {
                                                viewModel.onTapCircle(day: Int(day)!, uid: authViewModel.currentUser!.id)
                                                withAnimation {
                                                    proxy.scrollTo(day, anchor: .center)
                                                }
                                                Task {
                                                    await viewModel.fetchRecords(userId: authViewModel.currentUser!.id, isInitialize: false)
                                                }
                                            }
                                        }
                                    }
                                }
                                .padding()
                            }
                            .onAppear {
                                let todayDate = viewModel.getTodayDate()
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1)  {
                                    proxy.scrollTo(todayDate, anchor: .center)
                                }
                            }
                        }
                    }
                    
                    // 総支出表示
                    VStack(spacing: 8) {
                        HStack {
                            Text("トータル")
                                .font(.headline)
                                .fontWeight(.bold)
                                .foregroundColor(Color.gray)
                            Spacer()
                        }
                        .padding(.horizontal, 24)
                        
                        CaloriesConteiner(totalPayment: viewModel.totalPayment, goalPayment: 1500)
                    }
                    
                    // 支出
                    VStack(spacing: 8) {
                        HStack {
                            Text("支出")
                                .font(.headline)
                                .fontWeight(.bold)
                                .foregroundColor(Color.gray)
                            Spacer()
                        }
                        .padding(.horizontal, 24)
                        
                        ForEach(viewModel.paymentRecordList, id: \.id) { record in
                            RecordContainer(record: record)
                                .onLongPressGesture {
                                    selectedRecordId = record.id
                                    showDeleteConfirmation = true
                                }
                        }
                    }
                }
                .onAppear {
                    Task {
                        // 初期処理
                        await viewModel.initialize(uid: authViewModel.currentUser!.id)
                    }
                }
                
                if viewModel.isLoading {
                    ZStack {
                        Color.white.opacity(0.6)
                            .ignoresSafeArea()
                        ProgressView("Loading...")
                            .progressViewStyle(CircularProgressViewStyle())
                            .padding()
                    }
                    
                }
            }
            
        }
    }
}
