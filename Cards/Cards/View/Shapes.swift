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

    private enum Constants {
        static let half: CGFloat = 0.5
        static let startAngle: CGFloat = 0
        static let endAngle: CGFloat = 6.3
    }
    
    required init(size: CGSize, fillColor: CGColor) {
        super.init()
        guard let smallSideSize = [size.width, size.height].min() else {
            return
        }
        let centerX = size.width * Constants.half
        let centerY = size.height * Constants.half
        let center = CGPoint(x: centerX, y: centerY)
        let startAngle = Constants.startAngle
        let endAngle = Constants.endAngle
        let radius = smallSideSize * Constants.half
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

    private enum Constants {
        static let xPoint: CGFloat = 0
    }

    required init(size: CGSize, fillColor: CGColor) {
        super.init()
        guard let smallSideSize = [size.width, size.height].min() else {
            return
        }
        let halfHeightOfCard = size.height / 2
        let halfheightOfSquare = smallSideSize / 2
        let yPoint = halfHeightOfCard - halfheightOfSquare
        let xPoint = Constants.xPoint
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

    private enum Constants {
        static let lineWidth: CGFloat = 5
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
        self.lineWidth = Constants.lineWidth
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

    private enum Constants {
        static let countOfCircles = 15
        static let minRadiusCircle = 5
        static let maxRadiusCircle = 20
        static let startAngle: CGFloat = 0
        static let endAngle: CGFloat = 6.3
    }

    required init(size: CGSize, fillColor: CGColor) {
        super.init()
        let maxXPoint = Int(size.width)
        let maxYPoint = Int(size.height)
        let minRadiusCircle = Constants.minRadiusCircle
        let maxRadiusCircle = Constants.maxRadiusCircle
        let countOfCircle = Constants.countOfCircles
        let startAngle = Constants.startAngle
        let endAngle = Constants.endAngle
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

    private enum Constants {
        static let countLines = 15
        static let lineWidth: CGFloat = 3
    }

    required init(size: CGSize, fillColor: CGColor) {
        super.init()
        let countLines = Constants.countLines
        let lineWidth = Constants.lineWidth
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
