//
//  Shapes.swift
//  Cards

import UIKit

protocol ShapeLayerProtocol: CAShapeLayer {
    init(size: CGSize, fillColor: CGColor)
}

extension ShapeLayerProtocol {
    init() {
        fatalError("init() не может быть использован для создания экземпляра")
    }
}

// MARK: Лицевая сторона (Круг)
class CircleShape: CAShapeLayer, ShapeLayerProtocol {
    
    required init(size: CGSize, fillColor: CGColor) {
        super.init()
        // Расчитываем размеры и положение круга
        let radius = ([size.width,size.height].min() ?? 0) / 2
        let centerX = size.width / 2
        let centerY = size.height / 2
    
        // Рисуем круг
        let path = UIBezierPath.init(arcCenter: CGPoint.init(x: centerX, y: centerY), radius: radius, startAngle: 0, endAngle: .pi * 2, clockwise: true)
        path.close()
        
        // Инициализируем созданный путь
        self.path = path.cgPath
        // Меняем цвет
        self.fillColor = fillColor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Лицевая сторона (Квадрат)
class SquareShape: CAShapeLayer, ShapeLayerProtocol {
    required init(size: CGSize, fillColor: CGColor) {
        super.init()
        let edgeSize = ([size.width,size.height].min() ?? 0)
        let rect = CGRect.init(x: 0, y: 0, width: edgeSize, height: edgeSize)
        let path = UIBezierPath(rect: rect)
        path.close()
        self.path = path.cgPath
        self.fillColor = fillColor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Лицевая сторона (Крест)
class CrossShape: CAShapeLayer, ShapeLayerProtocol {
    required init(size: CGSize, fillColor: CGColor) {
        super.init()
        let path = UIBezierPath()
        path.move(to: CGPoint.init(x: 0, y: 0))
        path.addLine(to: CGPoint.init(x: size.width, y: size.height))
        path.move(to: CGPoint.init(x: 0, y: size.height))
        path.addLine(to: CGPoint.init(x: size.width, y: 0))
        self.path = path.cgPath
        self.strokeColor = fillColor
        self.lineWidth = 5
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Лицевая сторона (Залитая карточка)
class FIllShape: CAShapeLayer, ShapeLayerProtocol {
    required init(size: CGSize, fillColor: CGColor) {
        super.init()
        let rect = CGRect.init(x: 0, y: 0, width: size.width, height: size.height)
        let path = UIBezierPath.init(rect: rect)
        self.path = path.cgPath
        self.fillColor = fillColor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Рубашка (круги)
class BackSideCircle: CAShapeLayer, ShapeLayerProtocol {
    required init(size: CGSize, fillColor: CGColor) {
        super.init()
        let path = UIBezierPath()
        
        for _ in 1...15 {
            let randomX = Int.random(in: 0...Int(size.width))
            let randomY = Int.random(in: 0...Int(size.height))
            let center = CGPoint.init(x: randomX, y: randomY)
            path.move(to: center)
            let radius = Int.random(in: 5...15)
            path.addArc(withCenter: center, radius: CGFloat(radius), startAngle: 0, endAngle: .pi * 2, clockwise: true)
        }
        self.path = path.cgPath
        self.fillColor = fillColor
        self.strokeColor = fillColor
        self.lineWidth = 1
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Рубашка (линии)
class BackSideLine: CAShapeLayer, ShapeLayerProtocol {
    required init(size: CGSize, fillColor: CGColor) {
        super.init()
        let path = UIBezierPath()
        for _ in 1...15 {
            let randomXStart = Int.random(in: 0...Int(size.width))
            let randomYStart = Int.random(in: 0...Int(size.height))
            let randomXEnd = Int.random(in: 0...Int(size.width))
            let randomYEnd = Int.random(in: 0...Int(size.height))
            path.move(to: CGPoint.init(x: randomXStart, y: randomYStart))
            path.addLine(to: CGPoint.init(x: randomXEnd, y: randomYEnd))
        }
        self.path = path.cgPath
        self.fillColor = fillColor
        self.strokeColor = fillColor
        self.lineWidth = 3
        self.lineCap = .round
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
