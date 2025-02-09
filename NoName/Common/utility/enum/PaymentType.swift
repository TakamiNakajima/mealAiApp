
enum PaymentType: String, CaseIterable, Identifiable {
    case alcohol = "お酒"
    case eatingOut = "外食"
    case carfare = "交際費"
    case goods = "その他"
    
    var id: String { self.rawValue }
    
    var displayName: String {
        switch self {
        case .alcohol:
            return "お酒"
        case .eatingOut:
            return "外食"
        case .carfare:
            return "交際費"
        case .goods:
            return "その他"
        }
    }
}
