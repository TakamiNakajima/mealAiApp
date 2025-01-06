
enum MealType: String, CaseIterable, Identifiable {
    case stapleFood = "主食"
    case mainDish = "主菜"
    case sideDish = "副菜"
    case soup = "汁物"
    
    var id: String { self.rawValue }
    
    var displayName: String {
        switch self {
        case .stapleFood:
            return "主食"
        case .mainDish:
            return "主菜"
        case .sideDish:
            return "副菜"
        case .soup:
            return "汁物"
        }
    }
}
