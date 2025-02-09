import SwiftUI

struct CaloriesConteiner: View {
    var totalPayment: Int
    var goalPayment: Int
    
    var body: some View {
        
        ZStack {
            
            RoundedRectangle(cornerRadius: 10)
                .fill(Color(UIColor.systemGray6))
                .frame(height: 100)
                .shadow(color: .gray.opacity(0.3), radius: 2, x: 1, y: 1)

            VStack{
                
                HStack(spacing: 2) {
                    Text("\(totalPayment)")
                        .font(.title2)
                        .foregroundColor(Color("mainColorDark"))
                        .fontWeight(.bold)
                    
                    Text("円")
                        .font(.headline)
                        .foregroundColor(Color("mainColorDark"))
                        .fontWeight(.bold)
                        .padding(.top, 4)
                }
                
                ProgressView(value: 0.3)
                    .scaleEffect(x: 1, y: 2, anchor: .center)
                    .tint(Color("mainColorDark"))
                    .padding(.bottom, 10)
                    .padding(.horizontal, 24)
                
                HStack {
                    
                    HStack(spacing: 0) {
                        Text("\(0)")
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundColor(Color.gray)
                        Text("円")
                            .font(.subheadline)
                            .fontWeight(.bold)
                            .foregroundColor(Color.gray)
                    }
                    
                    Spacer()
                    
                    HStack(spacing: 0) {
                        Text("\(goalPayment)")
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundColor(Color.gray)
                        
                        Text("円")
                            .font(.subheadline)
                            .fontWeight(.bold)
                            .foregroundColor(Color.gray)
                    }
                }
                .padding(.horizontal, 12)
            }
        }
        .padding(.horizontal, 24)
    }
}
