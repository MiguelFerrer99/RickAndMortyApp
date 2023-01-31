//
//  DashedLineView.swift
//  RickAndMorty
//
//  Created by Miguel Ferrer Fornali on 31/1/23.
//

import UIKit

final class DashedLineView: UIView {
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        layer.sublayers?.forEach({ $0.removeFromSuperlayer() })
        let caShapeLayer = CAShapeLayer()
        caShapeLayer.strokeColor = UIColor.black.cgColor
        caShapeLayer.lineWidth = 1
        caShapeLayer.lineDashPattern = [7, 5]
        let cgPath = CGMutablePath()
        cgPath.addLines(between: [CGPoint.zero, CGPoint(x: rect.width, y: 0)])
        caShapeLayer.path = cgPath
        layer.addSublayer(caShapeLayer)
        heightAnchor.constraint(equalToConstant: 2).isActive = true
        setNeedsDisplay()
        layoutIfNeeded()
    }
}
