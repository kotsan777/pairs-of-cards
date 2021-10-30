//: A UIKit based Playground for presenting user interface
  
import UIKit
import PlaygroundSupport

protocol ShapeLayerProtocol: CAShapeLayer {
    init(size: CGSize, fillColor: CGColor)
}

extension ShapeLayerProtocol {
    init() {
        fatalError("init() не может быть использован для создания экземпляра")
    }
}

extension UIResponder {
    func responderChain() -> String {
        guard let next = next else {
            return String(describing: Self.self)
        }
        return String(describing: Self.self) + "->" + next.responderChain()
    }
}

protocol FlippableView: UIView {
    var isFlipped: Bool {get set}
    var flipCompletionHandler: ((FlippableView) -> Void)? {get set}
    func flip()
}

// MARK: ViewController
class MyViewController : UIViewController {
    
    
    // MARK: LifeCycle
    override func loadView() {
        let view = UIView()
        view.backgroundColor = .white
        self.view = view
        
        let firstCardView = CardView<CircleShape>(frame: CGRect.init(x: 0,
                                                                     y: 0,
                                                                     width: 150,
                                                                     height: 200),
                                                  color: .red)
        let secondCardView = CardView<CircleShape>(frame: CGRect(x: 200,
                                                                 y: 0,
                                                                 width: 150,
                                                                 height: 200),
                                                   color: .red)
        firstCardView.flipCompletionHandler = {card in
            card.superview?.bringSubviewToFront(card)
        }
        secondCardView.flipCompletionHandler = {card in
            card.superview?.bringSubviewToFront(card)
        }
        self.view.addSubview(firstCardView)
        self.view.addSubview(secondCardView)
        
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

// MARK: Класс отвечающий за сущность "Карта"
class CardView<ShapeType: ShapeLayerProtocol>: UIView,FlippableView {
    var color: UIColor!
    var isFlipped: Bool = false {
        didSet {
            self.setNeedsDisplay()
        }
    }
    var flipCompletionHandler: ((FlippableView) -> Void)?
    
    func flip() {
        let fromView = isFlipped ? frontSideView : backSideView
        let toView = isFlipped ? backSideView : frontSideView
        UIView.transition(from: fromView,
                          to: toView,
                          duration: 0.5,
                          options: [.transitionFlipFromTop],
                          completion: {_ in
                            self.flipCompletionHandler?(self)
                          })
        isFlipped.toggle()
    }
    
    private let margin: Int = 10
    
    lazy var frontSideView = getFrontSideView()
    
    lazy var backSideView = getBackSideView()
    
    var cornerRadius: Int = 20
    
    private var anchorPoint: CGPoint = CGPoint(x: 0, y: 0)
    
    private var startTouchPoint: CGPoint!
    
    // Возвращение представления лицевой стороны карточки
    private func getFrontSideView() -> UIView {
        let view = UIView(frame: self.bounds)
        view.backgroundColor = . white
        let shapeView = UIView(frame: CGRect(x: margin,
                                             y: margin,
                                             width: Int(self.bounds.width) - margin * 2,
                                             height: Int(self.bounds.height) - margin * 2))
        view.addSubview(shapeView)
        
        let shapeLayer = ShapeType.init(size: shapeView.frame.size, fillColor: color.cgColor)
        shapeView.layer.addSublayer(shapeLayer)
        
        view.layer.masksToBounds = true
        view.layer.cornerRadius = CGFloat(cornerRadius)
        return view
    }
    
    // Возвращает представление для обратной стороны карточки
    private func getBackSideView() -> UIView {
        let view = UIView(frame: self.bounds)
        view.backgroundColor = .white
        
        switch ["circle", "line"].randomElement()! {
        case "circle":
            let layer = BackSideCircle(size: self.bounds.size, fillColor: UIColor.black.cgColor)
            view.layer.addSublayer(layer)
        case "line":
            let layer = BackSideLine(size: self.bounds.size, fillColor: UIColor.black.cgColor)
            view.layer.addSublayer(layer)
        default:
            break
        }
        view.layer.masksToBounds = true
        view.layer.cornerRadius = CGFloat(cornerRadius)
        return view
    }
    
    // Установка границ представления
    private func setupBorders() {
        self.clipsToBounds = true
        self.layer.cornerRadius = CGFloat(cornerRadius)
        self.layer.borderWidth = 2
        self.layer.borderColor = UIColor.black.cgColor
    }
    
    // Отрисовка элементов внутри представления
    override func draw(_ rect: CGRect) {
        backSideView.removeFromSuperview()
        frontSideView.removeFromSuperview()
        
        if isFlipped {
            self.addSubview(backSideView)
            self.addSubview(frontSideView)
        } else {
            self.addSubview(frontSideView)
            self.addSubview(backSideView)
        }
    }
    
    // Обработчик касаний
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print(self.responderChain())
        anchorPoint.x = touches.first!.location(in: window).x - frame.minX
        anchorPoint.y = touches.first!.location(in: window).y - frame.minY
        startTouchPoint = self.frame.origin
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.frame.origin.x = touches.first!.location(in: window).x - anchorPoint.x
        self.frame.origin.y = touches.first!.location(in: window).y - anchorPoint.y
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if self.frame.origin == startTouchPoint {
            flip()
        }
    }
    
    
    // Инициализатор
    init(frame: CGRect, color: UIColor) {
        super.init(frame: frame)
        self.color = color
        if isFlipped {
            self.addSubview(backSideView)
            self.addSubview(frontSideView)
        } else {
            self.addSubview(frontSideView)
            self.addSubview(backSideView)
        }
        setupBorders()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


// Present the view controller in the Live View window
PlaygroundPage.current.liveView = MyViewController()
