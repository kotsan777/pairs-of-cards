//
//  CardViewFactory.swift
//  Cards

import UIKit

protocol CardViewFactoryProtocol {
    func get(_ shape: CardType, withSize size: CGSize, andColor color: CardColor) -> UIView
    func getViewColorBy(modelColor: CardColor) -> UIColor
}

class CardViewFactory: CardViewFactoryProtocol {
    func get(_ shape: CardType, withSize size: CGSize, andColor color: CardColor) -> UIView {
        let frame = CGRect(origin: .zero, size: size)
        
        let viewColor = getViewColorBy(modelColor: color)
        
        switch shape {
        case .circle:
            return CardView<CircleShape>.init(frame: frame, color: viewColor)
        case .cross:
            return CardView<CrossShape>.init(frame: frame, color: viewColor)
        case .square:
            return CardView<SquareShape>.init(frame: frame, color: viewColor)
        case .fill:
            return CardView<FIllShape>.init(frame: frame, color: viewColor)
        }
    }
    
    func getViewColorBy(modelColor: CardColor) -> UIColor {
        switch modelColor {
        case .red:
            return .red
        case .green:
            return .green
        case .black:
            return .black
        case .gray:
            return .gray
        case .brown:
            return .brown
        case .yellow:
            return .yellow
        case .purple:
            return .purple
        case .orange:
            return .orange
        }
    }
    
    
}
