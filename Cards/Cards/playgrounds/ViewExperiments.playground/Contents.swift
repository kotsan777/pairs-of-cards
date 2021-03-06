//: A UIKit based Playground for presenting user interface
  
import UIKit
import PlaygroundSupport

class MyViewController : UIViewController {
    override func loadView() {
        setupViews()
    }
    
    
    
    
    private func setupViews() {
        self.view = getRootView()
        let redView = getRedView()
        let greenView = getGreenView()
        let whiteView = getWhiteView()
        let pinkView = getPinkView()
        set(view: greenView, toCenterOfView: redView)
        // Позиционируем белое представление с помощью свойства center
        whiteView.center = greenView.center
        self.view.addSubview(redView)
        redView.addSubview(greenView)
        redView.addSubview(whiteView)
        self.view.addSubview(pinkView)
        redView.transform = CGAffineTransform.init(rotationAngle: .pi/3)
        set(view: greenView, toCenterOfView: redView)
    }
    
    private func getRootView() -> UIView {
        let view = UIView()
        view.backgroundColor = .gray
        return view
    }
    
    private func getRedView() -> UIView {
        let viewFrame = CGRect.init(x: 50, y: 50, width: 200, height: 200)
        let view = UIView.init(frame: viewFrame)
        view.backgroundColor = .red
        view.clipsToBounds = true
        return view
    }
    
    private func getGreenView() -> UIView {
        let viewFrame = CGRect.init(x: 0, y: 0, width: 180, height: 180)
        let view = UIView.init(frame: viewFrame)
        view.backgroundColor = .green
        return view
    }
    
    private func getWhiteView() -> UIView {
        let viewFrame = CGRect.init(x: 0, y: 0, width: 50, height: 50)
        let view = UIView.init(frame: viewFrame)
        view.backgroundColor = .white
        return view
    }
    
    private func getPinkView() -> UIView {
        let viewFrame = CGRect.init(x: 50, y: 300, width: 100, height: 100)
        let view = UIView.init(frame: viewFrame)
        view.backgroundColor = .systemPink
        view.layer.borderWidth = 5
        view.layer.borderColor = UIColor.yellow.cgColor
        view.layer.cornerRadius = 15
        view.layer.shadowOpacity = 1
        view.layer.shadowRadius = 20
        view.layer.shadowOffset = CGSize.init(width: 10, height: 20)
        view.layer.shadowColor = UIColor.white.cgColor
        view.layer.opacity = 0.7
        
        // Создаем слой
        let layer = CALayer()
        // изменяем цвет фона
        layer.backgroundColor = UIColor.black.cgColor
        // изменение размеров и положения
        layer.frame = CGRect.init(x: 10, y: 10, width: 20, height: 20)
        // изменение радиусов углов
        layer.cornerRadius = 10
        // добавление в иерархию слоев
        view.layer.addSublayer(layer)
        return view
    }
    
    private func set(view moveView: UIView, toCenterOfView baseView: UIView) {
        moveView.center = CGPoint.init(x: baseView.bounds.midX, y: baseView.bounds.midY)
    }
}

















// Present the view controller in the Live View window
PlaygroundPage.current.liveView = MyViewController()
