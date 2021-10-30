//: A UIKit based Playground for presenting user interface
  
import UIKit
import PlaygroundSupport

class MyViewController : UIViewController {
    override func viewDidLoad() {
        let view = UIView()
        view.backgroundColor = .white
        self.view = view
        createBezier(on: view)
    }
    
    
    
    
    private func createBezier(on view: UIView) {
        let shapeLayer = CAShapeLayer()
        view.layer.addSublayer(shapeLayer)
        shapeLayer.strokeColor = UIColor.gray.cgColor
        shapeLayer.lineWidth = 5
        shapeLayer.path = getHat().cgPath
        shapeLayer.fillColor = UIColor.green.cgColor
        shapeLayer.lineJoin = .round
        shapeLayer.strokeStart = 0
        shapeLayer.strokeEnd = 1
    }
    
    private func getPath() -> UIBezierPath {
        // Прямоугольниk
        let path = UIBezierPath()
        // Первый треугольник
        path.move(to: CGPoint.init(x: 50, y: 50))
        path.addLine(to: CGPoint.init(x: 150, y: 50))
        path.addLine(to: CGPoint.init(x: 150, y: 150))
        path.close()
        
        // Второй треугольник
        path.move(to: CGPoint.init(x: 50, y: 70))
        path.addLine(to: CGPoint.init(x: 150, y: 170))
        path.addLine(to: CGPoint.init(x: 50, y: 170))
        path.close()
        
        // Кривая
        path.move(to: CGPoint.init(x: 10, y: 10))
        path.addCurve(to: CGPoint.init(x: 200, y: 200),
                      controlPoint1: CGPoint.init(x: 200, y: 20),
                      controlPoint2: CGPoint.init(x: 20, y: 200))
        return path
    }
    
    private func getHat() -> UIBezierPath {
        let path = UIBezierPath()
        path.move(to: CGPoint.init(x: 100, y: 100))
        path.addArc(withCenter: CGPoint.init(x: 150, y: 100),
                    radius: 50,
                    startAngle: .pi,
                    endAngle: 0,
                    clockwise: true)
        path.addLine(to: CGPoint.init(x: 220, y: 100))
        path.addArc(withCenter: CGPoint.init(x: 220, y: 150),
                    radius: 50,
                    startAngle: .pi * 3/2,
                    endAngle: .pi / 2,
                    clockwise: true)
        path.addLine(to: CGPoint.init(x: 200, y: 200))
        path.addLine(to: CGPoint(x: 200, y: 260))
        path.addLine(to: CGPoint(x: 100, y: 260))
        path.addLine(to: CGPoint(x: 100, y: 200))
        path.addLine(to: CGPoint(x: 80, y: 200))
        path.addArc(withCenter: CGPoint.init(x: 80, y: 150),
                    radius: 50,
                    startAngle: .pi / 2,
                    endAngle: .pi * 3/2,
                    clockwise: true)
        path.close()
        return path
    }
    
    
    private func getAnotherPath() -> UIBezierPath {
        let centerPoint = CGPoint.init(x: 200, y: 200)
        let path = UIBezierPath.init(arcCenter: centerPoint, radius: 150, startAngle: .pi/5, endAngle: .pi, clockwise: true)
        return path
    }
    private func getOvalPath() -> UIBezierPath {
        let rect = CGRect.init(x: 50, y: 50, width: 200, height: 100)
        let path = UIBezierPath.init(ovalIn: rect)
        return path
    }
}





























// Present the view controller in the Live View window
PlaygroundPage.current.liveView = MyViewController()
