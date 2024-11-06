import Foundation
import FirebaseFirestore

struct Record: Identifiable, Codable {
    var id: String
    var title: String
    var type: Int
    var date: Date
    var imageURL: String?
    var price: Int
    
    static func fromJson(_ jsonDict: [String: Any]) -> Record? {
        guard let id = jsonDict["recordId"] as? String,
              let title = jsonDict["title"] as? String,
              let type = jsonDict["type"] as? Int,
              let timestamp = jsonDict["date"] as? Timestamp,
              let price = jsonDict["price"] as? Int,
              let imageURL = jsonDict["imageUrl"] as? String else {
            print("Error: Missing or invalid values in JSON")
            return nil
        }
                
        return Record(id: id,title: title, type: type, date: timestamp.dateValue(), imageURL: imageURL, price: price)
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
