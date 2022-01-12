//
//  BoardGameConstructor.swift
//  Cards
//
//  Created by Аслан Кутумбаев on 10.01.2022.
//

import UIKit

protocol BoardGameConstructorProtocol {
    var game: GameProtocol {get set}
    var cardViewFactory: CardViewFactoryProtocol {get set}
    var boardGameView: BoardGameViewProtocol {get set}
    var startButton: StartButtonProtocol {get set}
    init(game: GameProtocol, cardViewFactory: CardViewFactoryProtocol, boardGameView: BoardGameViewProtocol, startButton: StartButtonProtocol)
}

class BoardGameConstructor: BoardGameConstructorProtocol {
    var game: GameProtocol
    var cardViewFactory: CardViewFactoryProtocol
    var boardGameView: BoardGameViewProtocol
    var startButton: StartButtonProtocol

    required init(game: GameProtocol, cardViewFactory: CardViewFactoryProtocol, boardGameView: BoardGameViewProtocol, startButton: StartButtonProtocol) {
        self.game = game
        self.cardViewFactory = cardViewFactory
        self.boardGameView = boardGameView
        self.startButton = startButton
    }


}
