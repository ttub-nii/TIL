//
//  CircularProgressView.swift
//  StoryboardChai
//
//  Created by toby.with on 2021/07/15.
//

import UIKit

@IBDesignable @objc open class CircularProgressView: UIView {
    @IBInspectable dynamic open var circleWidth: CGFloat = 2 {
        didSet {
            borderLayer.lineWidth = circleWidth
        }
    }
    
    @IBInspectable dynamic open var progressWidth: CGFloat = 2 {
        didSet {
            progressLayer.lineWidth = progressWidth
        }
    }
    
    @IBInspectable dynamic open var circleColor: UIColor = .blue {
        didSet {
            borderLayer.strokeColor = circleColor.cgColor
        }
    }
    
    @IBInspectable dynamic open var progressColor: UIColor = .red {
        didSet {
            progressLayer.strokeColor = progressColor.cgColor
        }
    }
    
    @IBInspectable dynamic open var progress: CGFloat = 0.0 {
        didSet {
            progressLayer.strokeEnd = progress
        }
    }
    
    private let progressLayer = CAShapeLayer()
    
    private let borderLayer = CAShapeLayer()
    
    private var startAngle: CGFloat = 0.0
    
    private var endAngle: CGFloat = 0.0
    
    private var displayLink: CADisplayLink?
    
    private var destinationValue: CGFloat = 0.0
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    open override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    // MARK: - Overrides
    open override func layoutSubviews() {
        super.layoutSubviews()
        
        borderLayer.frame = bounds
        progressLayer.frame = bounds
        progressLayer.strokeEnd = progress
        let borderPath = borderStrokePath(bounds: bounds)
        let progressPath = progressStrokePath(bounds: bounds)
        borderLayer.path = borderPath
        progressLayer.path = progressPath
    }
    
    // MARK: - Helpers
    private func borderStrokePath(bounds: CGRect) -> CGPath {
        let center = CGPoint(x: bounds.midX, y: bounds.midY)
        let radius = bounds.midX
        let path = UIBezierPath(arcCenter: center,
                                radius: radius,
                                startAngle: startAngle,
                                endAngle: endAngle,
                                clockwise: true)
        return path.cgPath
    }
    
    private func progressStrokePath(bounds: CGRect) -> CGPath {
        let center = CGPoint(x: bounds.midX, y: bounds.midY)
        let radius = bounds.midX
        let path = UIBezierPath(arcCenter: center,
                                radius: radius,
                                startAngle: startAngle,
                                endAngle: endAngle,
                                clockwise: true)
        return path.cgPath
    }
    
    private func setup() {
        backgroundColor = .clear
        progressLayer.lineWidth = progressWidth
        borderLayer.lineWidth = progressWidth
        
        progressLayer.fillColor = UIColor.clear.cgColor
        borderLayer.fillColor = UIColor.clear.cgColor
        
        layer.addSublayer(borderLayer)
        layer.addSublayer(progressLayer)
        
        startAngle = CGFloat(-(Double.pi * 0.5))
        endAngle   = CGFloat(3.0 / 4.0 * (Double.pi * 2.0))
    }
}
