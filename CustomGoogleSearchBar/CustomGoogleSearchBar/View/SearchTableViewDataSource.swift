import UIKit
import SDWebImage

class SearchResultTableViewDataSource: NSObject, UITableViewDataSource {
    
    var followers: [User] {
        didSet {
            var viewModels: [SearchResultCellViewModel] = []
            for user in followers {
                viewModels.append(SearchResultCellViewModel(user: user))
            }
            searchResults = viewModels
        }
    }
    
    private var searchResults: [SearchResultCellViewModel] = []
    
    init(_ followers:[User]) {
        self.followers = followers
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let searchResult = searchResults[indexPath.row]
        var cell = tableView.dequeueReusableCell(withIdentifier: UITableViewCell.identifier, for: indexPath)
        if cell.detailTextLabel == nil {
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: UITableViewCell.identifier)
        }

        cell.imageView?.sd_setImage(with: URL(string: searchResult.avatar_url), placeholderImage: UIImage(named: "avatar"))
        cell.textLabel?.text = searchResult.name
        cell.detailTextLabel?.text = searchResult.created_at
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
}
