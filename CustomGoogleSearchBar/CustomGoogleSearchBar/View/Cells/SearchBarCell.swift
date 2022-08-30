import UIKit

class SearchBarCell: UITableViewCell, CellConfigurable {

    var iconHistory: UIImageView = UIImageView()
    var iconSearch: UIImageView = UIImageView()
    var deleteButton = UIButton()
    var historyLabel = UILabel()
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        let bgColorView = UIView()
        bgColorView.backgroundColor = .clear
        selectedBackgroundView = bgColorView
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
    }
    
    var viewModel: SearchBarCellViewModel?
    
    func configure(viewModel: RowViewModel) {
        guard let viewModel = viewModel as? SearchBarCellViewModel else { return }

        self.viewModel = viewModel

        let typingKeyword = viewModel.typingKeyword
        let name = viewModel.name

        iconHistory.isHidden = typingKeyword == "" ? false : true
        iconSearch.isHidden = typingKeyword == "" ? true : false
        
        iconHistory.image = UIImage(named: "history_clock")
        iconSearch.image = UIImage(named: "search")

        historyLabel.textColor = .hex6C757D
                
        if typingKeyword.count <= name.count {
            let mutableString = NSMutableAttributedString(string: name, attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16)])
            mutableString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.hex1458E2, range: NSRange(location:0,length:typingKeyword.count))
            historyLabel.attributedText = mutableString
        } else {
            let mutableString = NSMutableAttributedString(string: name, attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16)])
            mutableString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.hex1458E2, range: NSRange(location:0,length:0))
            historyLabel.attributedText = mutableString
        }
        
        historyLabel.numberOfLines = 0
        historyLabel.font = UIFont.systemFont(ofSize: 16)
        
        deleteButton.isHidden = typingKeyword == "" ? false : true
//        deleteButton.tag = index
        deleteButton.setImage(UIImage(named: "close_gray"), for: .normal)
        deleteButton.addTarget(self, action: #selector(deleteButtonClick), for: .touchUpInside)

        contentView.addSubviewForAutoLayout(iconHistory)
        contentView.addSubviewForAutoLayout(iconSearch)
        contentView.addSubviewForAutoLayout(historyLabel)
        contentView.addSubviewForAutoLayout(deleteButton)
        
        NSLayoutConstraint.activate([
            iconHistory.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            iconHistory.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 0),
            iconHistory.widthAnchor.constraint(equalToConstant: 13),
            iconHistory.heightAnchor.constraint(equalToConstant: 11),
            
            iconSearch.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            iconSearch.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 0),
            iconSearch.widthAnchor.constraint(equalToConstant: 16),
            iconSearch.heightAnchor.constraint(equalToConstant: 16),

            historyLabel.leadingAnchor.constraint(equalTo: iconSearch.trailingAnchor, constant: 12),
            historyLabel.trailingAnchor.constraint(equalTo: deleteButton.leadingAnchor, constant: -12),
            historyLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 8),
            historyLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -8),
            
            deleteButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -8),
            deleteButton.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 0),
            deleteButton.widthAnchor.constraint(equalToConstant: 12),
            deleteButton.heightAnchor.constraint(equalToConstant: 12)
        ])
    }
    
    @objc func deleteButtonClick(sender: UIButton) {
        viewModel?.deleteButtonPressed?()
    }
}
