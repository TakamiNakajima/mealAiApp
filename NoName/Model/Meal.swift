import Foundation
import FirebaseFirestore

struct Meal: Identifiable, Codable {
    var id: String
    var type: Int
    var date: Date
    var imageURL: String?
    var kcal: Int
    
    static func fromJson(_ jsonDict: [String: Any]) -> Meal? {
        guard let id = jsonDict["mealId"] as? String,
              let type = jsonDict["type"] as? Int,
              let timestamp = jsonDict["date"] as? Timestamp,
              let kcal = jsonDict["kcal"] as? Int,
              let imageURL = jsonDict["imageUrl"] as? String else {
            print("Error: Missing or invalid values in JSON")
            return nil
        }
                
        return Meal(id: id, type: type, date: timestamp.dateValue(), imageURL: imageURL, kcal: kcal)
    }
    
    func toJson() -> Data? {
        let encoder = JSONEncoder()
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        encoder.dateEncodingStrategy = .formatted(dateFormatter)
        
        do {
            let jsonData = try encoder.encode(self)
            return jsonData
        } catch {
            print("Error encoding to JSON: \(error)")
            return nil
        }
    }
}
