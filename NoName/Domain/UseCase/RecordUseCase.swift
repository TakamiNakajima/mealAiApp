import Foundation

class RecordUseCase {
    let recordRepository = RecordRepository()
    // 記録をDBに保存する
    func createRecord(type: Int, title: String, userId: String, date: String, price: Int) async {
        
    }
    
    // 記録をDBから取得する
    func readRecord() async {
        
    }
    
    // 記録を更新する
    func updateecord() async {
        
    }
    
    // 記録をDBから削除する
    func deleteRecord(recordId: String, userId: String) async -> Bool {
        do {
            try await recordRepository.deleteRecord(recordId: recordId, userId: userId)
        } catch {
            return false
        }
        return true
    }
}
