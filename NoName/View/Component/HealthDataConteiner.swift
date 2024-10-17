import SwiftUI

struct HealthDataConteiner: View {
    var title: String
    var value: String
    var isStep: Bool
    var body: some View {
        ZStack {
            
            RoundedRectangle(cornerRadius: 10)
                .fill(Color(UIColor.systemGray6))
                .frame(width: 160, height: 100)
            
            VStack {
                HStack {
                    Text(title)
                        .font(.subheadline)
                        .padding(5)
                        .foregroundColor(.gray)
                    
                    Spacer()
                }
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                
                Spacer()
                
                HStack(alignment: VerticalAlignment.bottom, spacing: 2){
                    Spacer()
                    
                    Text(value)
                        .font(.title)
                        .foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
                        .fontWeight(.bold)
                    
                    Text((isStep) ? "歩" : "kcal")
                        .font(.headline)
                        .foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
                        .fontWeight(.bold)
                        .padding(.bottom, 2)
                    
                }
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                
            }
            .frame(width: 160, height: 100)
            
        }
    }
}
