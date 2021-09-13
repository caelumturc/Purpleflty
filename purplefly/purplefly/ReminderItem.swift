//
import Foundation

struct purpleItem: Codable {
    
    // MARK: - Properties
    var id = UUID().uuidString
    var title: String
    var dueDate: Date?
    var isCompleted = false
}
