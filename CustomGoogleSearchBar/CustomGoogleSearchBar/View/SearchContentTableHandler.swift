import Foundation
import UIKit

class SearchContentTableHandler: NSObject, UITableViewDataSource, UITableViewDelegate {
    var followers: [User] = []
    
    var controller: SearchViewController
    
    init(controller: SearchViewController) {
        self.controller = controller
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchedContentTableViewCell.identifier, for: indexPath) as? SearchedContentTableViewCell else { return UITableViewCell() }
        cell.textLabel?.text = followers[indexPath.row].name
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return followers.count
    }
}
