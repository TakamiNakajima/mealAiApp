import SwiftUI

struct CaloriesConteiner: View {
    var totalKcal: Int
    var goalKcal: Int
    
    var body: some View {
        
        ZStack {
            
            RoundedRectangle(cornerRadius: 10)
                .fill(Color(UIColor.systemGray6))
                .frame(height: 100)
            
            VStack{
                ProgressView(value: Double(totalKcal), total: Double(goalKcal))
                    .scaleEffect(x: 1, y: 2, anchor: .center)
                    .tint(.blue)
                    .padding(.vertical, 10)
                    .padding(.horizontal, 24)
                
                HStack {
                    
                    HStack(spacing: 0) {
                        Text("\(totalKcal)")
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
                        Text("\(goalKcal)")
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
