import Foundation

class UserDefaultManager: NSObject {
    static let `default` = UserDefaultManager()

    var searchedHistories: [User] {
        set {
            let data = try! JSONEncoder().encode(newValue)
            UserDefaults.standard.set(data, forKey: "searchedHistories")
        }
        get {
            if let d = UserDefaults.standard.data(forKey: "searchedHistories") {
              let stored = try! JSONDecoder().decode([User].self, from: d)
              return stored
            } else {
                return []
            }
        }
    }
}
