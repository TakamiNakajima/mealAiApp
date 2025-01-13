import Foundation

enum SaleArea: String, CaseIterable {
    case vegetable = "野菜"
    case seasoning = "調味料"
    case fish = "魚"
    case meat = "肉"
    case milk = "乳製品"
    case bread = "パン"
    case other = "その他"

    /// 文字列ラベルをSaleAreaに変換
    static func toSaleArea(_ label: String) -> SaleArea? {
        return SaleArea(rawValue: label)
    }

    /// Enumの文字列ラベル
    func toLabel() -> String {
        return self.rawValue
    }
}
