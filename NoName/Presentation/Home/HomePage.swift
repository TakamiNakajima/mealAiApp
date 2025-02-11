import SwiftUI

struct HomePage: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject var viewModel: HomePageViewModel
    @State private var showDeleteConfirmation = false
    @State private var selectedRecord: Record?
    let generator = UIImpactFeedbackGenerator(style: .light)
    
    var body: some View {
        if let currentUser = authViewModel.currentUser {
            ZStack {
                ScrollView {
                    VStack(spacing: 20) {
                        
                        VStack {
                            Text("\(String(viewModel.selectedYear))年\(viewModel.selectedMonth)月")
                                .font(.headline)
                                .fontWeight(.regular)
                                .foregroundColor(Color("mainColorLight"))
                            
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
                                                        generator.impactOccurred()
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
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
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
                        
                        // 支出一覧
                        VStack(spacing: 8) {
                            HStack {
                                Text("支出")
                                    .font(.headline)
                                    .fontWeight(.bold)
                                    .foregroundColor(Color.gray)
                                Spacer()
                            }
                            .padding(.horizontal, 24)
                            
                            LazyVStack(spacing: 12) {
                                ForEach(viewModel.paymentRecordList, id: \.id) { record in
                                    Button {
                                        generator.impactOccurred()
                                        selectedRecord = record
                                        showDeleteConfirmation = true
                                    } label: {
                                        RecordContainer(record: record)
                                    }
                                    
                                }
                            }
                        }
                    }
                    .padding(.bottom, 20)
                }
                .onAppear {
                    Task {
                        await viewModel.initialize(uid: authViewModel.currentUser!.id)
                    }
                }
                .alert("削除しますか？", isPresented: $showDeleteConfirmation) { 
                    Button("キャンセル", role: .cancel) {}
                    Button("OK") {
                        Task {
                            await viewModel.deleteRecord(recordId: selectedRecord!.id, userId: currentUser.id)
                            await viewModel.fetchRecords(userId: currentUser.id, isInitialize: true)
                        }
                    }
                } message: {
                    if (selectedRecord != nil) {
                        Text("\(selectedRecord!.title) \(selectedRecord!.price)円")
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
