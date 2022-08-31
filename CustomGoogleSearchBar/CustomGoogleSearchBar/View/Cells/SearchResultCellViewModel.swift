import UIKit

class SearchResultCellViewModel: RowViewModel {
    
    let avatar_url: String
    let name: String
    let created_at: String

    init(user: User) {
        self.name = user.name ?? ""
        self.avatar_url = user.avatar_url ?? ""
        if let created_at = user.created_at {
            self.created_at = DateFormatters.dateFormatter_yyyyMMdd.string(from: created_at)
        } else {
            self.created_at = ""
        }
    }
}
