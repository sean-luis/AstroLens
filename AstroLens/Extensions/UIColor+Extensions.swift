import UIKit

extension UIColor {
    
    // MARK: - ViewController background colours
    // Write hexadecimal notation in Swift using 0x prefix, e.g "fd79a8" becomes "0xfd79a8"
    
    static var defaultBackgroundColor: UIColor { return .systemBackground }
    static var flatPink: UIColor { return UIColor(rgb: 0xfd79a8) }
    static var flatPurple: UIColor { return UIColor(rgb: 0xa29bfe) }
    static var flatBlue: UIColor { return UIColor(rgb: 0x74b9ff) }
    static var flatGreen: UIColor { return UIColor(rgb: 0x55efc4) }
    static var spaceBlack: UIColor { return UIColor(rgb: 0x1e272e) }
    static var shipsOfficer: UIColor { return UIColor(rgb: 0x2C3A47) }
    
    // nasaBlue
    
    // MARK: - Hexadecimal converter
    
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")

        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }

    convenience init(rgb: Int) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF
        )
    }
}
