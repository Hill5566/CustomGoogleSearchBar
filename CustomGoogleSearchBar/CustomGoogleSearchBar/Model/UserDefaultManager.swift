import Foundation

class UserDefaultManager: NSObject {
    static let `default` = UserDefaultManager()

    var searchedWordHistories: [User] {
        set {
            let data = try! JSONEncoder().encode(newValue)
            UserDefaults.standard.set(data, forKey: "searchedWordHistories")
        }
        get {
            if let d = UserDefaults.standard.data(forKey: "searchedWordHistories") {
              let stored = try! JSONDecoder().decode([User].self, from: d)
              return stored
            } else {
                return []
            }
        }
    }
}
