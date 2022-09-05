import Foundation
import UIKit
import TTGTags

class SearchViewController: UIViewController {

    private let viewModel = SearchViewModel()
    
    private var mSearchResultTableView = UITableView()
    private var mSearchResultTableViewLayoutTop = NSLayoutConstraint()
    private var mSearchResultTableViewDataSource = SearchResultTableViewDataSource([])

    @IBOutlet weak var mSearchBarBackgroundView: UIView!
    @IBOutlet weak var mSearchBar: UISearchBar!
    private let mSearchBarTableView = UITableView()
    private var mSearchBarTableViewLayoutHeight = NSLayoutConstraint()
    @IBOutlet weak var mTrendingLabel: UILabel!
    private let mTagScrollView = TTGTextTagCollectionView()
    
    @IBOutlet weak var mDateRangeLabel: UILabel!
    
    lazy private var mNoResultLabel: UILabel = {
        let label = UILabel()
        label.text = "No Result"
        label.isHidden = true
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        setupSearchBar()
        setupTagScrollView()
        setupTableView()
        setupNoResultLabel()
        
        viewModel.searchBarText.bind { [weak self] text in
            guard let self = self else { return }
            self.mSearchBar.text = text
            self.showTimeSelector()
            self.view.endEditing(true)
            self.mSearchBarTableView.isHidden = true
        }
        
        viewModel.sectionViewModels.bind { [weak self] sectionViewModels in
            guard let self = self else { return }
            self.mSearchBarTableView.isHidden = false
            self.mSearchBarTableView.reloadData()
            self.mSearchBarTableView.layoutIfNeeded()
            self.dynamicSearchBarTableViewHeight()
        }

        viewModel.popularKeywords.bind(fireNow: true) { [weak self] keywords in
            guard let self = self else { return }
            self.reloadTabScrollView(keywords: keywords)
        }
                
        viewModel.followers.bind { [weak self] followers in
            guard let self = self else { return }
            if followers.count == 0 {
                self.mNoResultLabel.isHidden = false
            } else {
                self.mNoResultLabel.isHidden = true
            }
            self.mSearchResultTableViewDataSource.followers = followers
            self.mSearchResultTableView.reloadData()
        }
        
        viewModel.dateRange.bind { [weak self] dateRange in
            guard let self = self else { return }
            switch dateRange {
            case .customRange:
                guard let beginDate = self.viewModel.beginDate, let endDate = self.viewModel.endDate else { return }
                self.mDateRangeLabel.text = DateFormatters.format_yyyyMMdd.string(from: beginDate) + " - " + DateFormatters.format_yyyyMMdd.string(from: endDate)
            default:
                self.mDateRangeLabel.text = dateRange.rawValue
            }
            self.viewModel.loadUserFollowers(name: self.viewModel.searchBarText.value)
        }
    }
    
    func setupSearchBar() {
        mSearchBar.compatibleSearchTextField.backgroundColor = .clear
        mSearchBar.borderColor = .hexDEE2E6
    }
    
    func setupTableView() {
                
        mSearchBarTableView.dataSource = self
        mSearchBarTableView.delegate = self
        mSearchBarTableView.register(SearchBarCell.self, forCellReuseIdentifier: SearchBarCell.identifier)
        mSearchBarTableView.isHidden = true
        mSearchBarTableView.separatorStyle = .none
        mSearchBarTableView.isScrollEnabled = false
        mSearchBarTableView.rowHeight = UITableView.automaticDimension
        mSearchBarTableView.borderColor = .hexDEE2E6
        mSearchBarTableView.borderWidth = 2
        mSearchBarTableView.cornerRadius = 4
        
        mSearchResultTableView.register(UITableViewCell.self, forCellReuseIdentifier: UITableViewCell.identifier)
        mSearchResultTableView.dataSource = mSearchResultTableViewDataSource
        mSearchResultTableView.separatorStyle = .none
                
        view.addSubviewForAutoLayout(mSearchResultTableView)
        view.addSubviewForAutoLayout(mSearchBarTableView)
        
        mSearchResultTableViewLayoutTop = mSearchResultTableView.topAnchor.constraint(equalTo: mSearchBarBackgroundView.bottomAnchor, constant: 8)
        NSLayoutConstraint.activate([
            mSearchBarTableView.topAnchor.constraint(equalTo: mSearchBar.bottomAnchor, constant: -1),
            mSearchBarTableView.leadingAnchor.constraint(equalTo: mSearchBar.leadingAnchor, constant: 0),
            mSearchBarTableView.trailingAnchor.constraint(equalTo: mSearchBar.trailingAnchor, constant: 0),
            mSearchResultTableViewLayoutTop,
            mSearchResultTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20),
            mSearchResultTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            mSearchResultTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 20)
        ])
        mSearchBarTableViewLayoutHeight = mSearchBarTableView.heightAnchor.constraint(equalToConstant: 60)
        mSearchBarTableViewLayoutHeight.isActive = true
    }

    func setupTagScrollView() {
        
        mTagScrollView.delegate = self
        mTagScrollView.scrollDirection = .horizontal
        mTagScrollView.showsHorizontalScrollIndicator = false
        view.addSubviewForAutoLayout(mTagScrollView)

        NSLayoutConstraint.activate([
            mTagScrollView.topAnchor.constraint(equalTo: mSearchBar.bottomAnchor, constant: 10),
            mTagScrollView.heightAnchor.constraint(equalToConstant: 60),
            mTagScrollView.leadingAnchor.constraint(equalTo: mTrendingLabel.trailingAnchor, constant: 12),
            mTagScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24)
        ])
    }
    
    func setupNoResultLabel() {
        
        mSearchResultTableView.addSubviewForAutoLayout(mNoResultLabel)
        NSLayoutConstraint.activate([
            mNoResultLabel.centerXAnchor.constraint(equalTo: mSearchResultTableView.centerXAnchor, constant: 0),
            mNoResultLabel.centerYAnchor.constraint(equalTo: mSearchResultTableView.centerYAnchor, constant: 0)
        ])
    }
    
    fileprivate func showTimeSelector() {
        mSearchResultTableViewLayoutTop.constant = 42
    }
    fileprivate func dynamicSearchBarTableViewHeight() {
        mSearchBarTableViewLayoutHeight.constant = mSearchBarTableView.contentSize.height
    }
    fileprivate func reloadTabScrollView(keywords: [AirtableKeyword]) {
        mTagScrollView.removeAllTags()
        for item in keywords {
            let content = TTGTextTagStringContent.init(text: item.keyword)
            content.textColor = .hex6C757D
            content.textFont = UIFont.systemFont(ofSize: 16)
            
            let normalStyle = TTGTextTagStyle.init()
            normalStyle.backgroundColor = .hexF7F7F7
            normalStyle.extraSpace = CGSize.init(width: 16, height: 16)
            normalStyle.borderColor = .hexDEE2E6
            normalStyle.cornerRadius = 4
            normalStyle.shadowColor = .clear
            
            let tag = TTGTextTag.init()
            tag.content = content
            tag.style = normalStyle
            tag.selectedStyle = normalStyle
            
            mTagScrollView.addTag(tag)
        }
        mTagScrollView.reload()
    }
    
    @IBAction func timeSelectorClick(_ sender: UIButton) {
        let vc = DateRangeSelectorVC()
        vc.modalPresentationStyle = .overCurrentContext
        vc.view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        vc.viewModel.dateRange.value = viewModel.dateRange.value
        vc.selectedDateRangeCallback = { [weak self] dateRange in
            guard let self = self else { return }
            self.viewModel.dateRange.value = dateRange
            self.viewModel.loadUserFollowers(name: self.viewModel.typingKeyword.value)
        }
        vc.customDateRangeCallback = { [weak self] fromDate, toDate in
            guard let self = self else { return }
            self.viewModel.beginDate = fromDate
            self.viewModel.endDate = toDate
            self.viewModel.dateRange.value = .customRange
            self.viewModel.loadUserFollowers(name: self.viewModel.typingKeyword.value)
            self.dismiss(animated: false, completion: nil)
        }
        present(vc, animated: true, completion: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
        mSearchBarTableView.isHidden = true
    }
}

extension SearchViewController: UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        guard let text = searchBar.text else { return }
        viewModel.loadSuggestUsers(text: text)
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text else { return }
        viewModel.addSearchedWordHistory(text: text)
        viewModel.loadUserFollowers(name: text)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard let text = searchBar.text else { return }
        viewModel.loadSuggestUsers(text: text)
    }
}

extension SearchViewController: TTGTextTagCollectionViewDelegate {
    func textTagCollectionView(_ textTagCollectionView: TTGTextTagCollectionView!, didTap tag: TTGTextTag!, at index: UInt) {
        viewModel.loadUserFollowers(name: viewModel.popularKeywords.value[Int(index)].keyword)
    }
}

extension SearchViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.sectionViewModels.value.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionViewModel = viewModel.sectionViewModels.value[section]
        return sectionViewModel.rowViewModels.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let sectionViewModel = viewModel.sectionViewModels.value[indexPath.section]
        let rowViewModel = sectionViewModel.rowViewModels[indexPath.row]

        let cell = tableView.dequeueReusableCell(withIdentifier: viewModel.cellIdentifier(for: rowViewModel), for: indexPath)

        if let cell = cell as? CellConfigurable {
            cell.configure(viewModel: rowViewModel)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let sectionViewModel = viewModel.sectionViewModels.value[indexPath.section]
        if let rowViewModel = sectionViewModel.rowViewModels[indexPath.row] as? ViewModelPressible {
            rowViewModel.cellPressed?()
        }
    }

    
//    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
//        let customView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 60))
//        let button = UIButton()
//        button.setTitleColor(.hex7F7F7F, for: .normal)
//        button.setTitle("Clear history", for: .normal)
//        button.titleLabel?.font = UIFont.systemFont(ofSize: 13)
//        button.addTarget(self, action: #selector(clearHistoryAction(_:)), for: .touchUpInside)
//        button.borderWidth = 1
//        button.cornerRadius = 4
//        button.borderColor = .hexDEE2E6
//        customView.addSubviewForAutoLayout(button)
//        NSLayoutConstraint.activate([
//            button.leadingAnchor.constraint(equalTo: customView.leadingAnchor, constant: 20),
//            button.trailingAnchor.constraint(equalTo: customView.trailingAnchor, constant: -20),
//            button.centerYAnchor.constraint(equalTo: customView.centerYAnchor, constant: 0),
//            button.heightAnchor.constraint(equalToConstant: 33)
//        ])
//        return customView
//    }
//
//    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
//        return viewModel.typingKeyword.value == "" ? 60 : 0
//    }
    
     @objc func clearHistoryAction(_ sender: UIButton) {
         viewModel.searchedWordHistories.value = []
     }
}
