import Foundation

struct Meal: Identifiable, Codable {
    var id: String
    var type: Int
    var date: Date
    var imageURL: String?
    
    static func fromJson(_ jsonData: Data) -> Meal? {
        let decoder = JSONDecoder()
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
        
        do {
            let meal = try decoder.decode(Meal.self, from: jsonData)
            return meal
        } catch {
            print("Error decoding JSON: \(error)")
            return nil
        }
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
