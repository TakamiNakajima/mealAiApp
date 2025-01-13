import Foundation

enum UnitType: String, CaseIterable {
    /// 各単位の定義
    case individual = "個"
    case stalk = "本"
    case bulb = "玉"
    case bunch = "束"
    case sheet = "枚"
    case cluster = "房"
    case gram = "g"
    case kilogram = "kg"
    case cup = "カップ"
    case tablespoon = "大さじ"
    case teaspoon = "小さじ"
    case milliliter = "mL"
    case liter = "L"
    case piece = "片"
    case pinch = "少々"
    case pack = "袋"
    case toTaste = "適量"

    /// 文字列ラベルをUnitTypeに変換
    static func toUnitType(_ label: String) -> UnitType? {
        return UnitType(rawValue: label)
    }

    /// Enumの文字列ラベル
    func toLabel() -> String {
        return self.rawValue
    }
}
