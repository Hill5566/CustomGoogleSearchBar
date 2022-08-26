import UIKit

class SearchBarHistoryCell: UITableViewCell {

    static let identifier = String(describing: self)
    
    var iconHistory: UIImageView = UIImageView()
    var iconSearch: UIImageView = UIImageView()
    var closeButton = UIButton()
    var historyLabel = UILabel()
    var deleteCallback:((Int)->())?
    
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
    
    func configure(data: SearchViewModel, index:Int) {
        
        let searchKeyword = data.typingKeyword.value

        iconHistory.isHidden = searchKeyword == "" ? false : true
        iconSearch.isHidden = searchKeyword == "" ? true : false
        
        iconHistory.image = UIImage(named: "history_clock")
        iconSearch.image = UIImage(named: "search")

        historyLabel.textColor = .hex6C757D
                
        if searchKeyword.count <= (data.suggestUsers.value[index].name ?? "").count {
            let mutableString = NSMutableAttributedString(string: data.suggestUsers.value[index].name ?? "", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16)])
            mutableString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.hex1458E2, range: NSRange(location:0,length:searchKeyword.count))
            historyLabel.attributedText = mutableString
        } else {
            let mutableString = NSMutableAttributedString(string: data.suggestUsers.value[index].name ?? "", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16)])
            mutableString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.hex1458E2, range: NSRange(location:0,length:0))
            historyLabel.attributedText = mutableString
        }
        
        historyLabel.numberOfLines = 0
        historyLabel.font = UIFont.systemFont(ofSize: 16)
        
        closeButton.isHidden = searchKeyword == "" ? false : true
        closeButton.tag = index
        closeButton.setImage(UIImage(named: "close_gray"), for: .normal)
        closeButton.addTarget(self, action: #selector(closeButtonClick), for: .touchUpInside)

        addSubviewForAutoLayout(iconHistory)
        addSubviewForAutoLayout(iconSearch)
        addSubviewForAutoLayout(historyLabel)
        addSubviewForAutoLayout(closeButton)
        
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
            historyLabel.trailingAnchor.constraint(equalTo: closeButton.leadingAnchor, constant: -12),
            historyLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 8),
            historyLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -8),
            
            closeButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -8),
            closeButton.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 0),
            closeButton.widthAnchor.constraint(equalToConstant: 12),
            closeButton.heightAnchor.constraint(equalToConstant: 12)
        ])
    }
    
    @objc func closeButtonClick(sender: UIButton) {
        deleteCallback?(sender.tag)
    }
}
