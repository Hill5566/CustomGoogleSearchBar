import Foundation

class SearchViewModel {
    
    init() {
        loadSearchedWrodHistories()
        loadSearchPopularKeywords()
    }
    
    let searchBarText: Box<String> = Box("")
    
    let sectionViewModels = Box<[SectionViewModel]>([])
    let typingKeyword:Box<String> = Box("")
    func loadSuggestUsers(text:String) {
        typingKeyword.value = text
        if text == "" {
            sectionViewModels.value = buildViewModels(searchs: searchedWordHistories.value)
        } else {
            loadRecommendUsers(prefix: text)
        }
    }
    func buildViewModels(searchs: [Search]) -> [SectionViewModel] {
        var vm: [RowViewModel] = []
        for (index, search) in searchs.enumerated() {
            if let user = search as? User, let name = user.name {
                let searchBarCellViewModel = SearchBarCellViewModel(typingKeyword: typingKeyword.value, user: user)
                searchBarCellViewModel.cellPressed = { [weak self] in
                    guard let self = self else { return }
                    self.searchBarText.value = name
                    self.loadUserFollowers(name: self.searchBarText.value)
                }
                searchBarCellViewModel.deleteButtonPressed = { [weak self] in
                    guard let self = self else { return }
                    self.searchedWordHistories.value.remove(at: index)
                    UserDefaultManager.default.searchedWordHistories = self.searchedWordHistories.value
                    print(self.searchedWordHistories.value)
                    self.loadSuggestUsers(text: "")
                }
                vm.append(searchBarCellViewModel)
            }
        }
        return [SectionViewModel(rowViewModels: vm)]
    }
    func loadRecommendUsers(prefix:String) {
        Api.getGithubUsers { [weak self] users, error in
            guard let self = self, let users = users else { return }
                        
            self.sectionViewModels.value = self.buildViewModels(searchs: users.filter {
                if let name = $0.name {
                    return name.lowercased().hasPrefix(prefix.lowercased())
                }
                return false
            })
        }
    }
    
    let searchedWordHistories:Box<[User]> = Box([])
    func loadSearchedWrodHistories() {
        searchedWordHistories.value = UserDefaultManager.default.searchedWordHistories
    }
    func addSearchedWordHistory(text: String) {
        if text == "" {
            return
        }
        var histories = searchedWordHistories.value
        histories = histories.filter {
            if let name = $0.name {
                return name != text
            } else {
                return false
            }
        }
        histories.insert(User(name: text), at: 0)
        if histories.count > 5 {
            histories.removeLast()
        }
        searchedWordHistories.value = histories
        UserDefaultManager.default.searchedWordHistories = searchedWordHistories.value
    }
    
    let popularKeywords:Box<[String]> = Box([])
    func loadSearchPopularKeywords() {
//        api.getSearchPopular { [weak self] keywords in
//            guard let self = self, let keywords = keywords else { return }
//            self.popularKeywords.value = keywords
//        }
        self.popularKeywords.value = ["John", "Tom", "Joe", "JoJo"]
    }
    
    let followers: Box<[User]> = Box([])
    let dateRange:Box<DateRange> = Box(.anyTime)
    var beginDate:String? = nil
    var endDate:String? = nil
    func loadUserFollowers(name: String?) {
        
        guard let name = name else { return }
        if name == "" {
            return
        }
        
        searchBarText.value = name
        typingKeyword.value = name
        
        switch dateRange.value {
        case .anyTime:
            beginDate = nil
            endDate = nil
        case .past24hours:
            beginDate = DateFormatters.dateFormatter_yyyyMMddTHHmmssSSSz.string(from: Calendar.current.date(byAdding: .day, value: -1, to: Date()) ?? Date())
            endDate = DateFormatters.dateFormatter_yyyyMMddTHHmmssSSSz.string(from: Date())
        case .pastWeek:
            beginDate = DateFormatters.dateFormatter_yyyyMMddTHHmmssSSSz.string(from: Calendar.current.date(byAdding: .day, value: -7, to: Date()) ?? Date())
            endDate = DateFormatters.dateFormatter_yyyyMMddTHHmmssSSSz.string(from: Date())
        case .pastMonth:
            beginDate = DateFormatters.dateFormatter_yyyyMMddTHHmmssSSSz.string(from: Calendar.current.date(byAdding: .month, value: -1, to: Date()) ?? Date())
            endDate = DateFormatters.dateFormatter_yyyyMMddTHHmmssSSSz.string(from: Date())
        case .pastYear:
            beginDate = DateFormatters.dateFormatter_yyyyMMddTHHmmssSSSz.string(from: Calendar.current.date(byAdding: .year, value: -1, to: Date()) ?? Date())
            endDate = DateFormatters.dateFormatter_yyyyMMddTHHmmssSSSz.string(from: Date())
        case .customRange:
            break
        case .none:
            beginDate = nil
            endDate = nil
        }
        
        Api.getGithubUserFollowers(name: name) { [weak self] followers, error in
            guard let self = self else { return }
            
            if let _ = error {
                self.followers.value = []
                return
            }
            
            guard let followers = followers else { return }
            
            self.followers.value = followers
        }
    }
    
    func cellIdentifier(for viewModel: RowViewModel) -> String {
        switch viewModel {
        case is SearchBarCellViewModel:
            return SearchBarCell.identifier
        default:
            fatalError("Unexpected view model type: \(viewModel)")
        }
    }
}
