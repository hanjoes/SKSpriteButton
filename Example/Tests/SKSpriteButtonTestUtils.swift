import UIKit

extension UIColor {
    
    /// Check whether `self` is equivalent to another color.
    /// Converting both colors to RGB color space.
    ///
    /// - Parameter color: another color
    /// - Returns: Boolean indicating whether two colors are equivalent
    func isEquivalent(to color: UIColor) -> Bool {
        var red: CGFloat = 1.0
        var green: CGFloat = 1.0
        var blue: CGFloat = 1.0
        var alpha: CGFloat = 1.0
        
        getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        
        var _red: CGFloat = 1.0
        var _green: CGFloat = 1.0
        var _blue: CGFloat = 1.0
        var _alpha: CGFloat = 1.0
        
        color.getRed(&_red, green: &_green, blue: &_blue, alpha: &_alpha)
        
        return red == _red && green == _green && blue == _blue && alpha == _alpha
    }
}
