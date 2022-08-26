import Foundation

struct SearchedContent: Codable {
    var index: Int?
    var name: String?
    var imageUrl: String?
    var publishTime: Date?
    
    enum CodingKeys: String, CodingKey {
        case index
        case name
        case imageUrl
        case publishTime
    }
}

