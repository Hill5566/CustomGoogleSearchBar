import Foundation
import UIKit

class SearchContentTableHandler: NSObject, UITableViewDataSource, UITableViewDelegate {
    var searchedContents: [SearchedContent] = []
    
    var controller: SearchViewController
    
    init(controller: SearchViewController) {
        self.controller = controller
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchedContentTableViewCell.identifier, for: indexPath) as? SearchedContentTableViewCell else { return UITableViewCell() }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchedContents.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
}
