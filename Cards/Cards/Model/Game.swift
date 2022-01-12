//
//  Game.swift
//  Cards


import UIKit

protocol GameProtocol {
    var cards: [Card] {get set}
    init(cardPairs: Int)
    func refreshGame()
    func checkCards(_ firstCard: Card, _ secondCard: Card) -> Bool
}

class Game: GameProtocol {

    lazy var cards: [Card] = []
    
    private var cardsCount: Int = 0

    private var newCards: [Card] {
        var cards = [Card]()
        for _ in 1...cardsCount {
            guard let cardType = CardType.allCases.randomElement(), let cardColor = CardColor.allCases.randomElement() else {
                return cards
            }
            let randomCard = (type: cardType, color: cardColor)
            cards.append(randomCard)
        }
        return cards
    }

    required init(cardPairs: Int) {
        cardsCount = cardPairs
        cards = newCards
    }

    func refreshGame() {
        cards.removeAll()
        cards = newCards
    }

    func checkCards(_ firstCard: Card, _ secondCard: Card) -> Bool {
        firstCard == secondCard ? true : false
    }
}
