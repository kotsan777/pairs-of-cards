//
//  Cards.swift
//  Cards

import UIKit

protocol FlippableView: UIView {
    var isFlipped: Bool {get set}
    var flipCompletionHandler: ((FlippableView) -> Void)? {get set}
    func flip()
}

private enum Constants {
    static let cornerRadius: CGFloat = 20
    static let margin: CGFloat = 10
    static let animatingDuration: CGFloat = 0.5
    static let borderWidth: CGFloat = 2
}

class CardView<ShapeType: ShapeLayerProtocol>: UIView, FlippableView {

    private enum BackSideViewStates: CaseIterable {
        case circle
        case line
    }

    var isFlipped: Bool = false
    var flipCompletionHandler: ((FlippableView) -> Void)?

    lazy var frontSideView = getFrontSideView
    lazy var backSideView = getBackSideView

    private var color: UIColor?
    private var anchorPoint: CGPoint = CGPoint.zero
    private var startTouchPoint: CGPoint?

    private var getFrontSideView: UIView {
        let view = UIView(frame: bounds)
        guard let color = color else {
            return view
        }
        let margin = Constants.margin
        let width = bounds.width - margin * 2
        let height = bounds.height - margin * 2
        let origin = CGPoint(x: margin, y: margin)
        let size = CGSize(width: width, height: height)
        let rect = CGRect(origin: origin, size: size)
        let shapeView = UIView(frame: rect)
        let shapeLayer = ShapeType(size: size, fillColor: color.cgColor)
        view.addSubview(shapeView)
        shapeView.layer.addSublayer(shapeLayer)
        view.backgroundColor = . white
        view.layer.masksToBounds = true
        view.layer.cornerRadius = Constants.cornerRadius
        return view
    }

    private var getBackSideView: UIView {
        guard let randomState = BackSideViewStates.allCases.randomElement() else {
            return UIView()
        }
        let view = UIView(frame: bounds)
        let size = bounds.size
        let color = UIColor.black.cgColor
        switch randomState {
        case .circle:
            let layer = BackSideCircle(size: size, fillColor: color)
            view.layer.addSublayer(layer)
        case .line:
            let layer = BackSideLine(size: size, fillColor: color)
            view.layer.addSublayer(layer)
        }
        view.backgroundColor = .white
        view.layer.masksToBounds = true
        view.layer.cornerRadius = Constants.cornerRadius
        return view
    }

    init(frame: CGRect, color: UIColor) {
        super.init(frame: frame)
        self.color = color
        setupBorders()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func flip() {
        let fromView = isFlipped ? frontSideView : backSideView
        let toView = isFlipped ? backSideView : frontSideView
        flipAnimation(fromView: fromView, toView: toView)
        setNeedsDisplay()
        isFlipped.toggle()
    }
    
    override func draw(_ rect: CGRect) {
        backSideView.removeFromSuperview()
        frontSideView.removeFromSuperview()
        if isFlipped {
            addSubview(backSideView)
            addSubview(frontSideView)
        } else {
            addSubview(frontSideView)
            addSubview(backSideView)
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let firstTouch = touches.first else {
            return
        }
        anchorPoint.x = firstTouch.location(in: window).x - frame.minX
        anchorPoint.y = firstTouch.location(in: window).y - frame.minY
        startTouchPoint = frame.origin
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let firstTouch = touches.first else {
            return
        }
        frame.origin.x = firstTouch.location(in: window).x - anchorPoint.x
        frame.origin.y = firstTouch.location(in: window).y - anchorPoint.y

    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        frame.origin == startTouchPoint ? flip() : nil
    }

    private func setupBorders() {
        clipsToBounds = true
        layer.cornerRadius = Constants.cornerRadius
        layer.borderWidth = Constants.borderWidth
        layer.borderColor = UIColor.black.cgColor
    }

    private func flipAnimation(fromView: UIView, toView: UIView) {
        let duration = Constants.animatingDuration
        let animationOption = UIView.AnimationOptions.transitionFlipFromTop
        UIView.transition(from: fromView, to: toView, duration: duration, options: animationOption) {[weak self] _ in
            guard let self = self else {
                return
            }
            self.flipCompletionHandler?(self)
        }
    }
}

