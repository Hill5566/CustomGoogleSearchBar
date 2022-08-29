import UIKit

class SearchBarCellViewModel: RowViewModel, ViewModelPressible {
    
    let typingKeyword: String
    let iconHistory = UIImage(named: "history_clock")
    let iconSearch: AsyncImage
    let name: String
    var deleteButtonPressed:(()->())?
    
    var cellPressed: (() -> Void)?
    
    init(typingKeyword:String, name: String, image: AsyncImage) {
        self.typingKeyword = typingKeyword
        self.iconSearch = image
        self.name = name
    }
    
    
}
