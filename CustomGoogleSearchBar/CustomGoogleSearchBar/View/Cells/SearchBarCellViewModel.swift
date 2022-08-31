import UIKit

class SearchBarCellViewModel: RowViewModel, ViewModelPressible {
    
    let typingKeyword: String
    let avatar_url: String
    let name: String
    
    var cellPressed: (() -> Void)?
    var deleteButtonPressed:(()->())?

    init(typingKeyword: String, user: User) {
        self.typingKeyword = typingKeyword
        self.name = user.name ?? ""
        self.avatar_url = user.avatar_url ?? ""
    }
    
    
}
