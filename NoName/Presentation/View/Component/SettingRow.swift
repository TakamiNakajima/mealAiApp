import SwiftUI

struct SettingsRow: View {
    
    let imageName: String
    let title: String
    let tintColor: Color
    
    var body: some View {
        
        HStack(spacing: 12) {
            
            Image(systemName: imageName)
                .imageScale(.small)
                .font(.title)
                .foregroundColor(tintColor)
            
            Text(title)
                .font(.subheadline)
                .foregroundColor(.black)
            
        }
    }
}
