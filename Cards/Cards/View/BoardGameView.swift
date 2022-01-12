//
//  BoardGameView.swift
//  Cards
//
//  Created by Аслан Кутумбаев on 10.01.2022.
//

import UIKit
protocol BoardGameViewProtocol: UIView {
    init()
    init(color: UIColor, cornerRadius: CGFloat)
}

class BoardGameView: UIView, BoardGameViewProtocol{

    enum Constants: CGFloat {
        case boardMargin = 10
        case boardCornerRadius = 30
    }

    private var defaultCornerRadius: CGFloat = Constants.boardCornerRadius.rawValue
    private var defaultBackgroundColor: UIColor = UIColor.systemPink

    required init() {
        super.init(frame: CGRect())
        setupBoardGameView(color: defaultBackgroundColor, cornerRadius: defaultCornerRadius)
    }

    required init(color: UIColor, cornerRadius: CGFloat) {
        super.init(frame: CGRect())
        setupBoardGameView(color: color, cornerRadius: cornerRadius)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupBoardGameView(color: UIColor, cornerRadius: CGFloat) {
        translatesAutoresizingMaskIntoConstraints = false
        layer.backgroundColor = color.cgColor
        layer.cornerRadius = cornerRadius
    }

}
