import Foundation

struct DateFormatters {
    static let format_yyyyMMddTHHmmssSSSz: DateFormatter = {
        var dateFormatter = DateFormatter()
//        "2022-08-15T18:25:43.511Z"
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        return dateFormatter
    }()
    static let format_yyyyMMdd: DateFormatter = {
        var dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy年MM月dd日"
        return dateFormatter
    }()
}
