import Foundation

class Texts {
    // 記録タイプのタイトルを返す
    static func title(type: Int) -> String {
        if (type == 0) {
            return "支出"
        } else if (type == 1) {
            return "収入"
        } else {
            return ""
        }
    }
}
