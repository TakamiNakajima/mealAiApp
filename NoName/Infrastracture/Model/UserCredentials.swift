import Foundation
import SwiftData

@Model
class UserCredentials {
    var email: String
    var password: String

    init(email: String, password: String) {
        self.email = email
        self.password = password
    }
}
