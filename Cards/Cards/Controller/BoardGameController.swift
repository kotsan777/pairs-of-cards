//
//  BoardGameController.swift
//  Cards
//
//  Created by Аслан Кутумбаев on 25.10.2021.
//

import UIKit

protocol CardGamable: AnyObject {
    var game: GameProtocol {get set}
    var flippedCards: [FlippableView] {get set}
}

protocol CardGameUpdatable: CardGamable {
    func removeCardsFromView(fromViewController viewController: CardGamable)
    func flipCards(viewController: CardGamable)
    func checkCards(viewController: CardGamable) -> Bool
}

protocol BoardGameControllerProtocol: AnyObject {
    init(boardGameConstructor: BoardGameConstructorProtocol)
}

class BoardGameController: UIViewController, CardGameUpdatable, BoardGameControllerProtocol{

    private enum Constants {
        static let boardMargin: CGFloat = 10
        static let removeViewDuration: CGFloat = 0.3
    }

    var game: GameProtocol
    lazy var flippedCards = [FlippableView]()

    private var cardViews = [FlippableView]()
    private var startButton: StartButton
    private var boardGameView: BoardGameView
    private var cardViewFactory: CardViewFactoryProtocol
    private var boardGameConstructor: BoardGameConstructorProtocol
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

    func removeCardsFromView(fromViewController viewController: CardGamable) {
        guard let firstCard = viewController.flippedCards.first, let secondCard = viewController.flippedCards.last else {
            return
        }
        let duration = Constants.removeViewDuration
        let animation = { firstCard.layer.opacity = 0; secondCard.layer.opacity = 0 }
        UIView.animate(withDuration: duration, animations: animation) { _ in
            firstCard.removeFromSuperview()
            secondCard.removeFromSuperview()
            viewController.flippedCards.removeAll()
        }
    }

    func flipCards(viewController: CardGamable) {
        viewController.flippedCards.forEach { $0.flip() }
    }

    func checkCards(viewController: CardGamable) -> Bool {
        guard let firstCardTag = viewController.flippedCards.first?.tag,
              let secondCardTag = viewController.flippedCards.last?.tag else {
                  return false
              }
        let firstCard = viewController.game.cards[firstCardTag]
        let secondCard = viewController.game.cards[secondCardTag]
        return firstCard == secondCard
    }

    private func updateCardViews(viewController: CardGameUpdatable) {
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
            guard let self = self, let cardSuperView = flippedCard.superview else {
                return
            }
            cardSuperView.bringSubviewToFront(flippedCard)
            if flippedCard.isFlipped {
                self.addCardToFlippedCards(toViewController: self, card: flippedCard)
            } else {
                self.removeCardFromFlippedCards(fromViewController: self, card: flippedCard)
            }
            if self.flippedCards.count == 2 {
                self.updateCardViews(viewController: self)
            }
        }
    }

    private func addCardToFlippedCards(toViewController viewController: CardGamable, card: FlippableView) {
        viewController.flippedCards.append(card)
    }

    private func removeCardFromFlippedCards(fromViewController viewController: CardGamable, card: UIView) {
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
        let margin = Constants.boardMargin
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
