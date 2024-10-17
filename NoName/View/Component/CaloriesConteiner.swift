import SwiftUI

struct CaloriesConteiner: View {
    var body: some View {
        
        ZStack {
            
            RoundedRectangle(cornerRadius: 10)
                .fill(Color(UIColor.systemGray6))
                .frame(height: 120)
            
            ProgressView(value: 20, total: 100)
                .scaleEffect(x: 1, y: 2, anchor: .center)
                .tint(.blue)
                .padding()
            
        }
        .padding(.horizontal, 24)
    }
}
