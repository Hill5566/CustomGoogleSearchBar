import UIKit

class SearchBarCellViewModel: RowViewModel, ViewModelPressible {
    
    let typingKeyword: String
//    let iconHistory = UIImage(named: "history_clock")
//    let iconSearch: AsyncImage
    let name: String
    
    var cellPressed: (() -> Void)?
    var deleteButtonPressed:(()->())?

    init(typingKeyword: String, user: User) {
        self.typingKeyword = typingKeyword
//        self.iconSearch = image
        self.name = user.name ?? ""
    }
    
    
}
