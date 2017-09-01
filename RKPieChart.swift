//
//  RKPieChart.swift
//  Pods
//
//  Created by ridvan kuccuk on 31/08/2017.
//
//

import CoreGraphics

let π: CGFloat = CGFloat(Double.pi)

public class RKPieChart: UIView {
    
    fileprivate var items: [RKPieChartItem] = [RKPieChartItem]()
    
    var circleColor: UIColor = .white
    public var arcWidth: CGFloat = 75 {
        didSet {
            setNeedsLayout()
        }
    }
    var style: CGLineCap = .butt
    
    private let startAngle: CGFloat = 3 * π / 2
    private let endAngle: CGFloat = π / 2
    
    private var totalRatio: CGFloat = 0
    
    override public func draw(_ rect: CGRect) {
        
        let center = CGPoint(x:bounds.width/2, y: bounds.height/2)
        
        // radius of the view
        let radius: CGFloat = max(bounds.width, bounds.height)
        
        let arcWidth: CGFloat = self.arcWidth
        
        let circlePath = UIBezierPath(arcCenter: center,
                                radius: radius/2 - arcWidth/2,
                                startAngle: 0,
                                endAngle: 2 * π,
                                clockwise: true)
        
        // draw circle path
        circlePath.lineWidth = arcWidth
        circleColor.setStroke()
        circlePath.lineCapStyle = style
        circlePath.stroke()
        
        if (items.count > 0) {
            calculateAngles()
            drawCircle()
        }
    }
    
    convenience public init(items: [RKPieChartItem]) {
        self.init()
        self.items = items
    }
    
    private func drawCircle(){
        items.forEach { (item) in
            
            // Center of the view
            let center = CGPoint(x:bounds.width/2, y: bounds.height/2)
            
            // Radius of the view
            let radius: CGFloat = max(bounds.width, bounds.height)
            
            let arcWidth: CGFloat = self.arcWidth
            
            let circlePath = UIBezierPath(arcCenter: center,
                                          radius: radius/2 - arcWidth/2,
                                          startAngle: item.startAngle!,
                                          endAngle: item.endAngle!,
                                          clockwise: true)
            
            // draw circle path
            circlePath.lineWidth = arcWidth
            item.color.setStroke()
            circlePath.lineCapStyle = style
            circlePath.stroke()
        }
    }
    
    private func calculateAngles() {
        totalRatio = items.map({ $0.ratio }).reduce(0, { $0 + $1 })
        for (index, item) in items.enumerated() {
            item.startAngle = index == 0 ? 3 * π / 2 : items[index - 1].endAngle
            if items.count == 1 {
                totalRatio = 100
            }
            item.endAngle = item.startAngle! + (360 * item.ratio / totalRatio).degreesToRadians
            if item.endAngle! > 2 * π {
                item.endAngle = item.endAngle! - 2 * π
            }
        }
    }
    
}

private extension Int {
    var degreesToRadians: Double { return Double(self) * .pi / 180 }
}

private extension FloatingPoint {
    var degreesToRadians: Self { return self * .pi / 180 }
    var radiansToDegrees: Self { return self * 180 / .pi }
}
