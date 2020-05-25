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
