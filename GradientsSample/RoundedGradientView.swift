//
//  RoundedGradientView.swift
//  GradientsSample
//
//  Created by Oleksandr on 22.05.2020.
//  Copyright © 2020 Oleksandr Bezpalchuk. All rights reserved.
//

import UIKit

final class RoundedGradientView: UIView {
    @IBInspectable var radius: CGFloat = 16.0

    var stops: [NSNumber] = [0.0, 1.0]
    var colors: [CGColor] = [UIColor.clear.cgColor, UIColor.clear.cgColor] {
        didSet {
            addGradient()
        }
    }

    // 0 - vertical, 1 - horizontal
    var direction: Int = 1

    override func layoutSubviews() {
        super.layoutSubviews()
        addGradient()
    }

    private func addGradient() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = CGRect(x: bounds.origin.x, y: 0, width: bounds.width, height: bounds.height)

        gradientLayer.locations = stops

        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)

        gradientLayer.colors = colors
        gradientLayer.cornerRadius = radius

        layer.sublayers = []
        layer.addSublayer(gradientLayer)
    }
}

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

}
