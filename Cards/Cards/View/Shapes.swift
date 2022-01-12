//
//  Shapes.swift
//  Cards

import UIKit

protocol ShapeLayerProtocol: CAShapeLayer {
    init(size: CGSize, fillColor: CGColor)
}

extension ShapeLayerProtocol {
    init() {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Frontside of Card (Circle)
class CircleShape: CAShapeLayer, ShapeLayerProtocol {

    private enum Constants: CGFloat {
        case half = 0.5
        case startAngle = 0
        case endAngle = 6.3
    }
    
    required init(size: CGSize, fillColor: CGColor) {
        super.init()
        guard let smallSideSize = [size.width, size.height].min() else {
            return
        }
        let centerX = size.width * Constants.half.rawValue
        let centerY = size.height * Constants.half.rawValue
        let center = CGPoint(x: centerX, y: centerY)
        let startAngle = Constants.startAngle.rawValue
        let endAngle = Constants.endAngle.rawValue
        let radius = smallSideSize * Constants.half.rawValue
        let path = UIBezierPath(arcCenter: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        path.close()
        self.path = path.cgPath
        self.fillColor = fillColor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


// MARK: Frontside of Card (Square)
class SquareShape: CAShapeLayer, ShapeLayerProtocol {

    private enum Constants: CGFloat {
        case xPoint = 0
    }

    required init(size: CGSize, fillColor: CGColor) {
        super.init()
        guard let smallSideSize = [size.width, size.height].min() else {
            return
        }
        let halfHeightOfCard = size.height / 2
        let halfheightOfSquare = smallSideSize / 2
        let yPoint = halfHeightOfCard - halfheightOfSquare
        let xPoint = Constants.xPoint.rawValue
        let rect = CGRect(x: xPoint, y: yPoint, width: smallSideSize, height: smallSideSize)
        let path = UIBezierPath(rect: rect)
        path.close()
        self.path = path.cgPath
        self.fillColor = fillColor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Frontside of Card (Cross)
class CrossShape: CAShapeLayer, ShapeLayerProtocol {
    private enum Constants: CGFloat {
        case lineWidth = 5
    }

    required init(size: CGSize, fillColor: CGColor) {
        super.init()
        let leftTopPoint = CGPoint.zero
        let rightBottomPoint = CGPoint(x: size.width, y: size.height)
        let leftBottomPoint = CGPoint(x: 0, y: size.height)
        let rightTopPoint = CGPoint(x: size.width, y: 0)
        let path = UIBezierPath()
        path.move(to: leftTopPoint)
        path.addLine(to: rightBottomPoint)
        path.move(to: leftBottomPoint)
        path.addLine(to: rightTopPoint)
        self.path = path.cgPath
        self.strokeColor = fillColor
        self.lineWidth = Constants.lineWidth.rawValue
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Frontside of Card (Fill)
class FIllShape: CAShapeLayer, ShapeLayerProtocol {

    required init(size: CGSize, fillColor: CGColor) {
        super.init()
        let rect = CGRect(origin: .zero, size: size)
        let path = UIBezierPath(rect: rect)
        self.path = path.cgPath
        self.fillColor = fillColor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Backside of Card (Circles)
class BackSideCircle: CAShapeLayer, ShapeLayerProtocol {

    private enum Constants: CGFloat {
        case countOfCircles = 15
        case minRadiusCircle = 5
        case maxRadiusCircle = 20
        case startAngle = 0
        case endAngle = 6.3
    }

    required init(size: CGSize, fillColor: CGColor) {
        super.init()
        let maxXPoint = Int(size.width)
        let maxYPoint = Int(size.height)
        let minRadiusCircle = Int(Constants.minRadiusCircle.rawValue)
        let maxRadiusCircle = Int(Constants.maxRadiusCircle.rawValue)
        let countOfCircle = Int(Constants.countOfCircles.rawValue)
        let startAngle = Constants.startAngle.rawValue
        let endAngle = Constants.endAngle.rawValue
        let path = UIBezierPath()
        for _ in 1...countOfCircle {
            let randomX = Int.random(in: 0...maxXPoint)
            let randomY = Int.random(in: 0...maxYPoint)
            let center = CGPoint(x: randomX, y: randomY)
            path.move(to: center)
            let radius = CGFloat(Int.random(in: minRadiusCircle...maxRadiusCircle))
            path.addArc(withCenter: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        }
        self.path = path.cgPath
        self.fillColor = fillColor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Backside of Card (Lines)
class BackSideLine: CAShapeLayer, ShapeLayerProtocol {

    private enum Constants: CGFloat {
        case countLines = 15
        case lineWidth = 3
    }

    required init(size: CGSize, fillColor: CGColor) {
        super.init()
        let countLines = Int(Constants.countLines.rawValue)
        let lineWidth = Constants.lineWidth.rawValue
        let maxXPoint = Int(size.width)
        let maxYPoint = Int(size.height)
        let path = UIBezierPath()
        for _ in 1...countLines {
            let randomXStart = Int.random(in: 0...maxXPoint)
            let randomYStart = Int.random(in: 0...maxYPoint)
            let randomXEnd = Int.random(in: 0...maxXPoint)
            let randomYEnd = Int.random(in: 0...maxYPoint)
            let startPoint = CGPoint(x: randomXStart, y: randomYStart)
            let endPoint = CGPoint(x: randomXEnd, y: randomYEnd)
            path.move(to: startPoint)
            path.addLine(to: endPoint)
        }
        self.path = path.cgPath
        self.fillColor = fillColor
        self.lineWidth = lineWidth
        strokeColor = fillColor
        lineCap = .round
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
