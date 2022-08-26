import Foundation

class SearchViewModel {
    
    init() {
        loadSearchedHistories()
        loadSearchPopularKeywords() //tags
    }
    
    let typingKeyword:Box<String> = Box("")
    
    let suggestWords:Box<[String]> = Box([])
    func loadSuggestWords(text:String) {
        typingKeyword.value = text
        if text == "" {
            suggestWords.value = searchedHistories.value
        } else {
            loadsearchRecommendKeywords(prefix: text)
        }
    }
    
    let searchedHistories:Box<[String]> = Box([])
    func loadSearchedHistories() {
        searchedHistories.value = UserDefaultManager.default.searchedHistories
    }
    func addSearchedHistory(text:String) {
        var histories = searchedHistories.value
        histories = histories.filter { $0 != text }
        histories.insert(text, at: 0)
        if histories.count > 5 {
            histories.removeLast()
        }
        searchedHistories.value = histories
    }
    
    let popularKeywords:Box<[String]> = Box([])
    func loadSearchPopularKeywords() {
//        api.getSearchPopular { [weak self] keywords in
//            guard let self = self, let keywords = keywords else { return }
//            self.popularKeywords.value = keywords
//        }
        self.popularKeywords.value = ["John", "Tom", "Joe", "JoJo"]
    }
    
    let searchRecommendKeywords:Box<[String]> = Box([])
    func loadsearchRecommendKeywords(prefix:String) {
//        api.getSearchRecommendKeywords(prefix: prefix) { [weak self] keywords in
//            guard let self = self, let keywords = keywords else { return }
//            if keywords.count > 5 {
//                self.searchRecommendKeywords.value = Array(keywords.prefix(upTo: 5))
//            } else {
//                self.searchRecommendKeywords.value = keywords
//            }
//            self.suggestWords.value = self.searchRecommendKeywords.value.filter { $0.hasPrefix(prefix) }
//        }
    }
    
    let searchedContents: Box<[SearchedContent]> = Box([])
    let dateRange:Box<DateRange> = Box(.anyTime)
    var beginDate:String? = nil
    var endDate:String? = nil
    func loadSearchVods(keyword: String?) {
        typingKeyword.value = keyword ?? ""
        if keyword == nil {
            return
        }
        if typingKeyword.value == "" {
            return
        }
        
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
        
//        api.postSearch(keyword:keyword, id: tagId, beginDate: beginDate, endDate: endDate) { [weak self] (searchResults) in
//            guard let searchResults = searchResults, let self = self else { return }
//
//            var vods = [VodContent]()
//            for result in searchResults {
//
//                let publishTime:Date? = ISO8601DateFormatter().date(from:result.publishTime) ?? nil
//
//                vods.append(VodContent(index: nil, categoryId: "\(result.defaultCategoryID)", categoryName: result.defaultCategoryName, subCategoryId: nil, subCategoryName: nil, id: result.id, name: result.title, contentDescription: result.shortDescription, directors: "", stars: nil, year: nil, ageRatings: nil, imageURL: nil, imageBackgroundURL: result.image, imageHorizontalURL: nil, length: result.length, resolution: nil, orderType: "\(result.type)", trailerPresent: nil, available: nil, watched: nil, purchased: nil, pricings: nil, downloadable: false, tags: nil, scripts: nil, publishTime: publishTime, updated: nil))
//            }
//            self.vods.value = vods
//        }
    }
}
