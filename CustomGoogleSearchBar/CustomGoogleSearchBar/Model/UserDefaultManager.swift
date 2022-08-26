import Foundation

class UserDefaultManager: NSObject {
    static let `default` = UserDefaultManager()
    
    var searchedHistories: [String] {
        set { UserDefaults.standard.set(newValue, forKey: "searchedHistories") }
        get { return UserDefaults.standard.stringArray(forKey: "searchedHistories") ?? [] }
    }
}
