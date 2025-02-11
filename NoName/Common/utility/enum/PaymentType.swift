
enum PaymentType: String, CaseIterable, Identifiable {
    case convinience = "コンビニ"
    case store = "スーパー"
    case outEating = "外食"
    case carfare = "交通費"
    case goods = "物品"
    case closes = "服"
    case other = "その他"
    
    var id: String { self.rawValue }
    
    var displayName: String {
        switch self {
        case .convinience:
            return "コンビニ"
        case .store:
            return "スーパー"
        case .outEating:
            return "外食"
        case .carfare:
            return "交通費"
        case .goods:
            return "物品"
        case .closes:
            return "服"
        case .other:
            return "その他"
        }
    }
}
