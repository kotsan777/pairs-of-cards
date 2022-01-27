//
//  BoardGameController.swift
//  Cards
//
//  Created by Аслан Кутумбаев on 25.10.2021.
//

import UIKit
protocol BoardGameControllerProtocol: UIViewController {
    var game: GameProtocol {get set}
    var startButton: StartButtonProtocol {get set}
    var boardGameView: BoardGameViewProtocol {get set}
    var cardViewFactory: CardViewFactoryProtocol {get set}
    var boardGameConstructor: BoardGameConstructorProtocol {get set}
    var flippedCards: [FlippableView] {get set}
    var cardViews: [FlippableView] {get set}
    init(boardGameConstructor: BoardGameConstructorProtocol)
    func removeCardsFromView(fromViewController viewController: BoardGameControllerProtocol)
    func flipCards(viewController: BoardGameControllerProtocol)
    func checkCards(viewController: BoardGameControllerProtocol) -> Bool
}

class BoardGameController: UIViewController, BoardGameControllerProtocol{

    private enum Constants: Float {
        case boardMargin = 10
        case removeViewDuration = 0.3
    }

    var boardGameConstructor: BoardGameConstructorProtocol
    var game: GameProtocol
    var cardViewFactory: CardViewFactoryProtocol
    var boardGameView: BoardGameViewProtocol
    var startButton: StartButtonProtocol
    var cardViews = [FlippableView]()
    lazy var flippedCards = [FlippableView]()

    private lazy var cardSize = cardViewFactory.cardSize
    private lazy var cardMaxXCoordinate = Int(boardGameView.frame.width - cardSize.width)
    private lazy var cardMaxYCoordinate = Int(boardGameView.frame.height - cardSize.height)

    required init(boardGameConstructor: BoardGameConstructorProtocol) {
        self.boardGameConstructor = boardGameConstructor
        game = boardGameConstructor.game
        cardViewFactory = boardGameConstructor.cardViewFactory
        boardGameView = boardGameConstructor.boardGameView
        startButton = boardGameConstructor.startButton
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(startButton)
        view.addSubview(boardGameView)
        setupButtonConstraints(button:startButton)
        setupBoardConstraints(board:boardGameView, button: startButton)
        addTargetForButton(button: startButton, selector: #selector(startGame(_:)))
    }

    @objc func startGame(_ sender: UIButton) {
        game.refreshGame()
        let cards = getCardsBy(modelData: game.cards)
        placeCardsOnBoard(cards)
    }

    func removeCardsFromView(fromViewController viewController: BoardGameControllerProtocol) {
        guard let firstCard = viewController.flippedCards.first, let secondCard = viewController.flippedCards.last else {
            return
        }
        let duration = TimeInterval(Constants.removeViewDuration.rawValue)
        let animation = { firstCard.layer.opacity = 0; secondCard.layer.opacity = 0 }
        UIView.animate(withDuration: duration, animations: animation) { _ in
            firstCard.removeFromSuperview()
            secondCard.removeFromSuperview()
            viewController.flippedCards.removeAll()
        }
    }

    func flipCards(viewController: BoardGameControllerProtocol) {
        viewController.flippedCards.forEach { $0.flip() }
    }

    func checkCards(viewController: BoardGameControllerProtocol) -> Bool {
        guard let firstCardTag = viewController.flippedCards.first?.tag,
              let secondCardTag = viewController.flippedCards.last?.tag else {
                  return false
              }
        let firstCard = viewController.game.cards[firstCardTag]
        let secondCard = viewController.game.cards[secondCardTag]
        return firstCard == secondCard
    }

    func updateCardViews(viewController: BoardGameControllerProtocol) {
        let isSameCards = viewController.checkCards(viewController: viewController)
        if isSameCards {
            viewController.removeCardsFromView(fromViewController: viewController)
        } else {
            viewController.flipCards(viewController: viewController)
        }
    }

    private func placeCardsOnBoard(_ cards: [FlippableView]) {
        cardViews.forEach { $0.removeFromSuperview() }
        cardViews = cards
        cardViews.forEach { card in
            let randomXCoordinate = Int.random(in: 0...cardMaxXCoordinate)
            let randomYCoordinate = Int.random(in: 0...cardMaxYCoordinate)
            card.frame.origin = CGPoint(x: randomXCoordinate, y: randomYCoordinate)
            boardGameView.addSubview(card)
        }
    }

    private func getCardsBy(modelData: [Card]) -> [FlippableView] {
        var cardViews = [FlippableView]()
        modelData.enumerated().forEach { index, cardModel in
            let cardOne = cardViewFactory.get(cardModel.type, andColor: cardModel.color)
            let cardTwo = cardViewFactory.get(cardModel.type, andColor: cardModel.color)
            cardOne.tag = index
            cardTwo.tag = index
            cardViews.append(cardOne)
            cardViews.append(cardTwo)
        }
        cardViews.forEach { setupCompletionHandler(forCardView: $0) }
        return cardViews
    }

    private func setupCompletionHandler(forCardView card: FlippableView) {
        card.flipCompletionHandler = { [weak self] flippedCard in
            guard let strongSelf = self, let cardSuperView = flippedCard.superview else {
                return
            }
            cardSuperView.bringSubviewToFront(flippedCard)
            if flippedCard.isFlipped {
                strongSelf.addCardToFlippedCards(toViewController: strongSelf, card: flippedCard)
            } else {
                strongSelf.removeCardFromFlippedCards(fromViewController: strongSelf, card: flippedCard)
            }
            if strongSelf.flippedCards.count == 2 {
                strongSelf.updateCardViews(viewController: strongSelf)
            }
        }
    }

    private func addCardToFlippedCards(toViewController viewController: BoardGameControllerProtocol, card: FlippableView) {
        viewController.flippedCards.append(card)
    }

    private func removeCardFromFlippedCards(fromViewController viewController: BoardGameControllerProtocol, card: UIView) {
        let flippedCards = viewController.flippedCards as [UIView]
        let cardForRemove = card as UIView
        guard let cardIndex = flippedCards.firstIndex(of: cardForRemove) else {
            return
        }
        viewController.flippedCards.remove(at: cardIndex)
    }

    private func setupButtonConstraints(button: UIButton) {
        guard let safeArea = UIApplication.shared.windows.first?.safeAreaInsets else {
            return
        }
        let topPadding = safeArea.top
        let topConstraint = button.topAnchor.constraint(equalTo: view.topAnchor, constant: topPadding)
        let horizontalConstraint = button.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        view.addConstraints([topConstraint,horizontalConstraint])
    }

    private func setupBoardConstraints(board: UIView, button: UIView) {
        guard let safeArea = UIApplication.shared.windows.first?.safeAreaInsets else {
            return
        }
        let bottomPadding = safeArea.bottom
        let margin = CGFloat(Constants.boardMargin.rawValue)
        let leadingConstraint = board.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: margin)
        let trailingConstraint = board.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -margin)
        let topConstraint = board.topAnchor.constraint(equalTo: button.bottomAnchor, constant: margin)
        let bottomConstraint = board.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -bottomPadding)
        view.addConstraints([leadingConstraint,trailingConstraint,topConstraint,bottomConstraint])
    }

    private func addTargetForButton(button: UIButton, selector: Selector) {
        button.addTarget(nil, action: selector, for: .touchUpInside)
    }
}
