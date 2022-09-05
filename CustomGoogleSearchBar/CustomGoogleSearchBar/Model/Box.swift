import Foundation

final class Box<T> {
    
    typealias Listener = (T) -> Void
    var listener: Listener?
    
    var value: T {
        didSet {
            DispatchQueue.main.async {
                self.listener?(self.value)
            }
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
    
    func unbind() {
        listener = nil
    }
}
