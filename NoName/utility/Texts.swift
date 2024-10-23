import Foundation

class Texts {
    // 食事タイプのタイトルを返す
    static func title(type: Int) -> String {
        if (type == 0) {
            return "朝"
        } else if (type == 1) {
            return "昼"
        } else if (type == 2) {
            return "夜"
        } else {
            return "間食"
        }
    }
}
