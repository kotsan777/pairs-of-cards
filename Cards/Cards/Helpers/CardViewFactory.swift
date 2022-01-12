//
//  CardViewFactory.swift
//  Cards

import UIKit

protocol CardViewFactoryProtocol {
    var cardSize: CGSize {get set}
    func get(_ shape: CardType, andColor color: CardColor) -> FlippableView
}

class CardViewFactory: CardViewFactoryProtocol {

    var cardSize: CGSize

    init(cardSize: CGSize) {
        self.cardSize = cardSize
    }

    func get(_ shape: CardType, andColor color: CardColor) -> FlippableView {
        let frame = CGRect(origin: .zero, size: cardSize)
        let viewColor = getViewColorBy(modelColor: color)
        switch shape {
        case .circle:
            return CardView<CircleShape>(frame: frame, color: viewColor)
        case .cross:
            return CardView<CrossShape>(frame: frame, color: viewColor)
        case .square:
            return CardView<SquareShape>(frame: frame, color: viewColor)
        case .fill:
            return CardView<FIllShape>(frame: frame, color: viewColor)
        }
    }
    
    private func getViewColorBy(modelColor: CardColor) -> UIColor {
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
