import Foundation

final class Box<T> {
    
    typealias Listener = (T) -> Void
    var listener: Listener?
    
    var value: T {
        didSet {
            listener?(value)
        }
    }
    
    init(_ value: T) {
        self.value = value
    }
    
    func bind(fireNow: Bool = false, listener: Listener?) {
        self.listener = listener
        if fireNow {
            listener?(value)
        }
    }
}
