
import UIKit

extension UIColor {
    static let background_E5E5E5 = UIColor.white//UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1)
    
    static let hex7F7F7F = hexStringToUIColor(hex: "7F7F7F")
    static let hex6C757D = hexStringToUIColor(hex: "6C757D")
    static let hexDEE2E6 = hexStringToUIColor(hex: "DEE2E6")
    static let hexE5E5E5 = hexStringToUIColor(hex: "E5E5E5")

    static let hexF7F7F7 = hexStringToUIColor(hex: "F7F7F7")

    static let hex1458E2 = hexStringToUIColor(hex: "1458E2")
    
    static func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }

        if ((cString.count) != 6) {
            return UIColor.gray
        }

        var rgbValue:UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)

        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}
