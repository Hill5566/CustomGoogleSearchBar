import UIKit

class CustomRangeVC: UIViewController {

    public var okCallback:((Date, Date)->())?
    public var cancelCallback:(()->())?

    private var fromDate = Date()
    private var toDate = Date()
    
    @IBOutlet weak var fromDatePicker: UIDatePicker!
    @IBOutlet weak var toDatePicker: UIDatePicker!

    @IBAction func cancelClick(_ sender: UIButton) {
        cancelCallback?()
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func okClick(_ sender: UIButton) {
        
        okCallback?(fromDate, toDate)
    }
    
    @IBAction func fromDatePIcker(_ sender: UIDatePicker) {
        print(sender.date)
        fromDate = sender.date
    }
    
    @IBAction func toDatePIcker(_ sender: UIDatePicker) {
        print(sender.date)
        
        toDate = sender.date
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: Date()) {
            fromDate = yesterday
        }
        fromDatePicker.maximumDate = Calendar.current.date(byAdding: .day, value: -1, to: Date())
        toDatePicker.maximumDate = Date()
    }

    

}
