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
    var boardGameView: BoardGameView {get set}
    var startButton: StartButton {get set}
    init(game: GameProtocol, cardViewFactory: CardViewFactoryProtocol, boardGameView: BoardGameView, startButton: StartButton)
}

class BoardGameConstructor: BoardGameConstructorProtocol {
    var game: GameProtocol
    var cardViewFactory: CardViewFactoryProtocol
    var boardGameView: BoardGameView
    var startButton: StartButton

    required init(game: GameProtocol, cardViewFactory: CardViewFactoryProtocol, boardGameView: BoardGameView, startButton: StartButton) {
        self.game = game
        self.cardViewFactory = cardViewFactory
        self.boardGameView = boardGameView
        self.startButton = startButton
    }


}
