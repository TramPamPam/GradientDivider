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
        
    lazy var divider3 = GradientDivider(columnCount: 3, colorFrom: .red, colorTo: .green)
    
    lazy var divider4 = GradientDivider(columnCount: 4, colorFrom: .red, colorTo: .green)
    
    lazy var divider5 = GradientDivider(columnCount: 5, colorFrom: .red, colorTo: .green)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        gradientView.colors = [UIColor.red.cgColor, UIColor.green.cgColor]
        gradientView.stops = [0, 1]
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
            ($0 as? RoundedGradientView)?.colors = divider5.gradient(for: $0.tag)
            ($0 as? RoundedGradientView)?.stops = [0, 1]
        }
    }
    
}

final class GradientDivider {
    private struct GradientColor {
        var color: UIColor
        var progress: CGFloat
    }
    
    private let colors: [GradientColor]
    private let columnCount: Int
    
    init(columnCount: Int, colorFrom: UIColor, colorTo: UIColor) {
        
        self.columnCount = columnCount
        self.colors = [GradientColor(color: colorFrom, progress: 0.0),
                       GradientColor(color: UIColor(between: colorFrom, and: colorTo, progress: 0.5), progress: 0.5),
                       GradientColor(color: colorTo, progress: 1.0)]
    }
    
    var stops: [CGFloat] {
        stride(from: 0.0, through: 1.0, by: 1.0 / Double(columnCount))
            .map { CGFloat($0) }
    }
    
    func gradient(for position: Int) -> [CGColor] {
        let leftProgress: CGFloat = stops[position]
        let rightProgress: CGFloat = stops[position + 1]
        
        let leftColor = UIColor(between: startColor(for: leftProgress),
                                and: endColor(for: leftProgress),
                                progress: interval(for: leftProgress))
        
        let rightColor = UIColor(between: startColor(for: rightProgress),
                                 and: endColor(for: rightProgress),
                                 progress: interval(for: rightProgress))
        
        return [leftColor.cgColor, rightColor.cgColor]
    }

    private func interval(for totalProgress: CGFloat) -> CGFloat {
        totalProgress > 0.5 ? (totalProgress - 0.5) / 0.5 : totalProgress / 0.5
    }
    
    private func startColor(for totalProgress: CGFloat) -> UIColor {
        totalProgress > 0.5 ? colors[1].color : colors[0].color
    }
    
    private func endColor(for totalProgress: CGFloat) -> UIColor {
        totalProgress > 0.5 ? colors[2].color : colors[1].color
    }
}



