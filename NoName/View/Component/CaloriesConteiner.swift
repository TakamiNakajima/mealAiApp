import SwiftUI

struct CaloriesConteiner: View {
    var totalKcal: Int
    var goalKcal: Int
    
    var body: some View {
        
        ZStack {
            
            RoundedRectangle(cornerRadius: 10)
                .fill(Color(UIColor.systemGray6))
                .frame(height: 120)
            
            VStack{
                HStack {
                    
                    HStack(spacing: 2) {
                        Text("\(totalKcal)")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(Color.gray)
                            .padding(.bottom, 4)
                        Text("kcal")
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundColor(Color.gray)
                    }
                    
                    HStack(spacing: 2) {
                        Text("/ \(goalKcal)")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(Color.gray)
                            .padding(.bottom, 4)

                        Text("kcal")
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundColor(Color.gray)
                    }
                }
                
                ProgressView(value: Double(totalKcal), total: Double(goalKcal))
                    .scaleEffect(x: 1, y: 2, anchor: .center)
                    .tint(.blue)
                    .padding()
            }
            
        }
        .padding(.horizontal, 24)
    }
}
