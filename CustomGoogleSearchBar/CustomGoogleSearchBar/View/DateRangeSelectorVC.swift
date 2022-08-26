import UIKit

enum DateRange: String {
    case anyTime = "Any Time"
    case past24hours = "Past 24 Hours"
    case pastWeek = "Past Week"
    case pastMonth = "Past Month"
    case pastYear = "Past Year"
    case customRange = "Custom Range"
    case none
}

class DateRangeSelectorVC: UIViewController {
    
    public var selectedDateRangeCallback:((DateRange)->())?
    public var customDateRangeCallback:((Date, Date)->())?

    public let viewModel = DateRangeSelectorViewModel()
    
    @IBOutlet weak var mDateBackgroundView: UIView!
    
    @IBOutlet weak var mAnyTimeImageView: UIImageView!
    @IBOutlet weak var mPast24hoursImageView: UIImageView!
    @IBOutlet weak var mPastWeekImageView: UIImageView!
    @IBOutlet weak var mPastMonthImageView: UIImageView!
    @IBOutlet weak var mPastYearImageView: UIImageView!
    @IBOutlet weak var mCustomRangeImageView: UIImageView!
    
    @IBOutlet weak var mAnyTimeLabel: UILabel!
    @IBOutlet weak var mPast24hoursLabel: UILabel!
    @IBOutlet weak var mPastWeekLabel: UILabel!
    @IBOutlet weak var mPastMonthLabel: UILabel!
    @IBOutlet weak var mPastYearLabel: UILabel!
    @IBOutlet weak var mCustomRangeLabel: UILabel!
    
    @IBAction func dismissClick(_ sender: UIButton) {
        dismiss(animated: false, completion: nil)
    }
    @IBAction func anyTimeClick(_ sender: UIButton) {
        selectedDateRangeCallback?(.anyTime)
        dismiss(animated: false, completion: nil)
    }
    @IBAction func past24hoursClick(_ sender: UIButton) {
        selectedDateRangeCallback?(.past24hours)
        dismiss(animated: false, completion: nil)
    }
    @IBAction func pastWeekClick(_ sender: UIButton) {
        selectedDateRangeCallback?(.pastWeek)
        dismiss(animated: false, completion: nil)
    }
    @IBAction func pastMonthClick(_ sender: UIButton) {
        selectedDateRangeCallback?(.pastMonth)
        dismiss(animated: false, completion: nil)
    }
    @IBAction func pastYearClick(_ sender: UIButton) {
        selectedDateRangeCallback?(.pastYear)
        dismiss(animated: false, completion: nil)
    }
    @IBAction func customRangeClick(_ sender: UIButton) {
        mDateBackgroundView.isHidden = true
        let vc = CustomRangeVC()
        vc.modalPresentationStyle = .overCurrentContext
        vc.view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
        vc.okCallback = { [weak self] fromDate, toDate in
            guard let self = self else { return }
            self.customDateRangeCallback?(fromDate, toDate)
        }
        vc.cancelCallback = { [weak self] in
            guard let self = self else { return }
            self.mDateBackgroundView.isHidden = false
        }
        present(vc, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.dateRange.bind { [weak self] dateRange in
            guard let self = self else { return }
            switch dateRange {
            case .anyTime:
                self.mAnyTimeImageView.isHidden = false
                self.mAnyTimeLabel.font = UIFont(name: "Overpass-Bold", size: 16)
                self.mAnyTimeLabel.textColor = .black
            case .past24hours:
                self.mPast24hoursImageView.isHidden = false
                self.mPast24hoursLabel.font = UIFont(name: "Overpass-Bold", size: 16)
                self.mPast24hoursLabel.textColor = .black
            case .pastWeek:
                self.mPastWeekImageView.isHidden = false
                self.mPastWeekLabel.font = UIFont(name: "Overpass-Bold", size: 16)
                self.mPastWeekLabel.textColor = .black
            case .pastMonth:
                self.mPastMonthImageView.isHidden = false
                self.mPastMonthLabel.font = UIFont(name: "Overpass-Bold", size: 16)
                self.mPastMonthLabel.textColor = .black
            case .pastYear:
                self.mPastYearImageView.isHidden = false
                self.mPastYearLabel.font = UIFont(name: "Overpass-Bold", size: 16)
                self.mPastYearLabel.textColor = .black
            case .customRange:
                self.mCustomRangeImageView.isHidden = false
            case .none:
                break
            }
        }
    }
}
