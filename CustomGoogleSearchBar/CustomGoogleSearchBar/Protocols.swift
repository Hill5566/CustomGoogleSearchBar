import Foundation

protocol Search {
//    var id: String { get set }
//    var time: Date { get set }
}

protocol RowViewModel {}

protocol CellConfigurable {
    func configure(viewModel: RowViewModel)
}

protocol ViewModelPressible {
    var cellPressed: (()->Void)? { get set }
}
