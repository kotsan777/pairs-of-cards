//
//  StartButtonView.swift
//  Cards
//
//  Created by Аслан Кутумбаев on 10.01.2022.
//

import UIKit

protocol StartButtonProtocol: UIButton {
    init()
    init(width: CGFloat, height: CGFloat, cornerRadius: CGFloat)
}

class StartButton: UIButton, StartButtonProtocol {

    private enum Constants: CGFloat {
        case buttonWidth = 200
        case buttonHeight = 50
        case buttonCornerRadius = 15
    }

    private let defaultTitle = "StartGame"
    private let defaultColor = UIColor.black
    private let defaultBackgroundColor = UIColor.systemGray4
    private let defaultWidth = Constants.buttonWidth.rawValue
    private let defaultHeight = Constants.buttonHeight.rawValue
    private let defaultCornerRadius = Constants.buttonCornerRadius.rawValue

    required init() {
        super.init(frame: CGRect())
        setupButton(cornerRadius: defaultCornerRadius)
        setupSize(width: defaultWidth, height: defaultHeight)
    }

    required init(width: CGFloat, height: CGFloat, cornerRadius: CGFloat) {
        super.init(frame: CGRect())
        setupButton(cornerRadius: cornerRadius)
        setupSize(width: width, height: height)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupSize(width: CGFloat, height: CGFloat) {
        let widthConstraint = self.widthAnchor.constraint(equalToConstant: width)
        let heightConstraint = self.heightAnchor.constraint(equalToConstant: height)
        addConstraints([widthConstraint, heightConstraint])
    }

    private func setupButton(cornerRadius: CGFloat) {
        translatesAutoresizingMaskIntoConstraints = false
        setTitle(defaultTitle, for: .normal)
        setTitleColor(defaultColor, for: .normal)
        backgroundColor = defaultBackgroundColor
        layer.cornerRadius = cornerRadius
    }
}
