//
//  ViewController.swift
//  GradientsSample
//
//  Created by Oleksandr Bezpalchuk on 5/19/20.
//  Copyright © 2020 Oleksandr Bezpalchuk. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var gradientView: RoundedGradientView!
    
    @IBOutlet weak var stackView: UIStackView!
    
    @IBOutlet weak var stackView3: UIStackView!
    
    @IBOutlet weak var stackView5: UIStackView!
    
    let divider3 = GradientDivider(columnCount: 3)
    
    let divider4 = GradientDivider(columnCount: 4)
    
    let divider5 = GradientDivider(columnCount: 5)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        gradientView.colors = divider4.gradientColor.map { $0.color.cgColor }
        gradientView.stops = [0, 0.5, 1]
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        stackView.arrangedSubviews.forEach {
            ($0 as? RoundedGradientView)?.colors = divider4.gradient(for: $0.tag)
            ($0 as? RoundedGradientView)?.stops = [0, 1]
        }

        stackView3.arrangedSubviews.forEach {
            ($0 as? RoundedGradientView)?.colors = divider3.gradient(for: $0.tag)
            ($0 as? RoundedGradientView)?.stops = [0, 1]
        }

        stackView5.arrangedSubviews.forEach {
            ($0 as? RoundedGradientView)?.colors = divider3.gradient(for: $0.tag)
            ($0 as? RoundedGradientView)?.stops = [0, 1]
        }
    }
    
}

class GradientDivider {
    let gradientColor: [GradientColor]
    let columnCount: Int
    
    init(columnCount: Int, colors: [GradientColor] = [
        GradientColor(color: UIColor.blue,
                      progress: 0.0),
        GradientColor(color: UIColor.red,
                      progress: 0.5),
        GradientColor(color: UIColor.green,
                      progress: 0.1)
    ]) {
        self.columnCount = columnCount
        self.gradientColor = colors
    }
    
    var stops: [CGFloat] {
        stride(from: 0.0, through: 1.0, by: 1.0 / Double(columnCount))
            .map { CGFloat($0) }
    }
    
    func gradient(for position: Int) -> [CGColor] {
        let leftProgress: CGFloat = stops[position]
        let rightProgress: CGFloat = stops[position + 1]
        
        let leftColor = interpolate2(
            startColor(for: leftProgress),
            endColor(for: leftProgress),
            interval(for: leftProgress))
        
        let rightColor = interpolate2(
            startColor(for: rightProgress),
            endColor(for: rightProgress),
            interval(for: rightProgress))
        
        return [leftColor.cgColor, rightColor.cgColor]
    }
    
    func interpolate2(_ color1: UIColor, _ color2: UIColor, _ progress: CGFloat) -> UIColor {
        let a1 = color1.rgba.alpha
        let r1 = color1.rgba.red
        let g1 = color1.rgba.green
        let b1 = color1.rgba.blue
        
        let a2 = color2.rgba.alpha
        let r2 = color2.rgba.red
        let g2 = color2.rgba.green
        let b2 = color2.rgba.blue
        
        let progress2 = 1 - progress
        let newA = a1 * progress2 + a2 * progress
        let newR = r1 * progress2 + r2 * progress
        let newG = g1 * progress2 + g2 * progress
        let newB = b1 * progress2 + b2 * progress
        
        return UIColor(red: newR, green: newG, blue: newB, alpha: newA)
    }
    
    private func interval(for totalProgress: CGFloat) -> CGFloat {
        return totalProgress > 0.5 ? (totalProgress - 0.5) / 0.5 : totalProgress / 0.5
        
    }
    private func startColor(for totalProgress: CGFloat) -> UIColor {
        return totalProgress > 0.5 ? gradientColor[1].color : gradientColor[0].color
        
    }
    private func endColor(for totalProgress: CGFloat) -> UIColor {
        return totalProgress > 0.5 ? gradientColor[2].color : gradientColor[1].color
        
    }
}

struct GradientColor {
    var color: UIColor
    var progress: CGFloat
}

struct GradientRange {
    var from: Int
    var till: Int
}

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
