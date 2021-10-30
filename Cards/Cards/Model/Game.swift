//
//  Game.swift
//  Cards


import UIKit

protocol GameProtocol {
    func generateCards()
    func checkCards(_ firstCard: Card, _ secondCard: Card) -> Bool
}

class Game: GameProtocol {
    // кол-во уникальных пар карточек
    var cardsCount = 0
    // массив сгенерированных карточек
    var cards = [Card]()
    
    // Генерация массива случайных карт
    func generateCards() {
        var cards = [Card]()
        for _ in 0...cardsCount {
            let randomElement = (type: CardType.allCases.randomElement()!, color: CardColor.allCases.randomElement()!)
            cards.append(randomElement)
        }
        self.cards = cards
    }
    
    // ПРоверка эквивалентности карточек
    func checkCards(_ firstCard: Card, _ secondCard: Card) -> Bool {
        if firstCard == secondCard {
            return true
        } else {
            return false
        }
    }
}
