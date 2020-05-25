//
//  UIColor+Extension.swift
//  GradientsSample
//
//  Created by Oleksandr Bezpalchuk on 5/22/20.
//  Copyright © 2020 Oleksandr Bezpalchuk. All rights reserved.
//
import UIKit

extension UIColor {
    var rgba: (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        
        return (red, green, blue, alpha)
    }
    
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
    
    public convenience init?(hexString: String?) {
        guard let hexString = hexString?.uppercased() else { return nil }
        
        let start = hexString.hasPrefix("#") ? hexString.index(hexString.startIndex, offsetBy: 1) : hexString.startIndex
        let hexColor = String(hexString[start...])
        let scanner = Scanner(string: hexColor)
        var hexNumber: UInt64 = 0
        
        if !scanner.scanHexInt64(&hexNumber) {
            return nil
        }
        
        self.init(rgb: Int(hexNumber))
    }
    
    convenience init(between start: UIColor, and end: UIColor, progress: CGFloat) {
        let a1 = start.rgba.alpha
        let r1 = start.rgba.red
        let g1 = start.rgba.green
        let b1 = start.rgba.blue
        
        let a2 = end.rgba.alpha
        let r2 = end.rgba.red
        let g2 = end.rgba.green
        let b2 = end.rgba.blue
        
        let progress2 = 1 - progress
        let newA = a1 * progress2 + a2 * progress
        let newR = r1 * progress2 + r2 * progress
        let newG = g1 * progress2 + g2 * progress
        let newB = b1 * progress2 + b2 * progress
        
        self.init(red: newR, green: newG, blue: newB, alpha: newA)
    }
    
}
