import SwiftUI

struct RecordContainer: View {
    var isPaymentRecord: Bool
    var record: Record
    var body: some View {
        ZStack {
            
            RoundedRectangle(cornerRadius: 10)
                .fill(Color(UIColor.systemGray6))
                .frame(height: 50)
                .shadow(color: .gray.opacity(0.3), radius: 2, x: 1, y: 1)
            
                HStack {
                    Text(record.title)
                        .font(.subheadline)
                        .padding(5)
                        .foregroundColor(.gray)
                        .fontWeight(.bold)
                    
                    Spacer()
                    
                    HStack(spacing: 2) {
                        Text(title(isPayment: isPaymentRecord, text: record.price))
                            .font(.headline)
                            .foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
                            .fontWeight(.bold)
                        
                        Text("円")
                            .font(.subheadline)
                            .foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
                            .fontWeight(.bold)
                            .padding(.top, 2)
                    }
                }
        
                .padding(.horizontal, 12)
                .padding(.vertical, 4)
        }
        .padding(.horizontal, 24)
    }
    
    func title(isPayment: Bool, text: Int) -> String {
        if (isPayment) {
            return "-\(text)"
        } else {
            return "+\(text)"

        }
    }
}
