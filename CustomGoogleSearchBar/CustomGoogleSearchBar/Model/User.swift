import Foundation

struct User: Search, Codable, RowViewModel, ViewModelPressible {
    
    var typingKeyword: String?
    var cellPressed: (() -> Void)?

    var id: Int?
    var name: String?
    var avatar_url: String?
    var created_at: Date?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name = "login"
        case avatar_url
        case created_at
    }
}

