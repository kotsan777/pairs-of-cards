//
//  BoardGameController.swift
//  Cards
//
//  Created by Аслан Кутумбаев on 25.10.2021.
//

import UIKit

class BoardGameController: UIViewController {
    
    // MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(startButtonView)
        view.addSubview(boardGameView)
    }
    
    // экшн метод
    @objc func startGame(_ sender: UIButton) {
        print("button was pressed")
        game = getNewGame()
        let cards = getCardsBy(modelData: game.cards)
        placeCardsOnBoard(cards)
    }

    
    // кол-во уникальных пар карточек
    var cardsPairsCounts = 8
    // сущность игра
    lazy var game = getNewGame()
    
    private func getNewGame() -> Game {
        let game = Game()
        game.cardsCount = self.cardsPairsCounts
        game.generateCards()
        return game
    }
    
    // MARK: Кнопка для запуска/перезапуска игры
    lazy var startButtonView = getStartButtonView()
    
    private func getStartButtonView() -> UIButton {
        // Создаем кнопку
        let button = UIButton.init(frame: CGRect(x: 0, y: 0, width: 200, height: 50))
        
        // Получаем доступ к текущему окну
        let window = UIApplication.shared.windows[0]
        window.overrideUserInterfaceStyle = .light
        
        // Определяем отступ сверху от границ окна до safeArea
        let topPadding = window.safeAreaInsets.top
        
        // Изменяем положение кнопки
        button.center.x = view.center.x
        button.frame.origin.y = topPadding
        
        // Устанавливаем текст
        button.setTitle("Начать игру", for: .normal)
        
        // Цвет текста для обычного состояния
        button.setTitleColor(.black, for: .normal)
        
        // Цвет текста для нажатого состояния
        button.setTitleColor(.gray, for: .highlighted)
        
        // Фоновый цвет кнопки
        button.backgroundColor = .systemGray4
        
        // Скругляем углы
        button.layer.cornerRadius = 10
        
        // подключаем обработчик нажатия на кнопку
        button.addTarget(nil, action: #selector(startGame(_:)), for: .touchUpInside)

        return button
    }
    
    // MARK: Игровое поле
    lazy var boardGameView = getBoardGameView()
    
    private func getBoardGameView() -> UIView {
        // отступ игрового поля от ближайших элементов
        let margin: CGFloat = 10
        let boardView = UIView()
        
        // указываем координаты x и y
        boardView.frame.origin.x = margin
        let window = UIApplication.shared.windows[0]
        let topPadding = window.safeAreaInsets.top
        boardView.frame.origin.y = topPadding + startButtonView.frame.height + margin
        
        // Расчитываем ширину
        boardView.frame.size.width = UIScreen.main.bounds.width - margin * 2
        
        // Расчитываем высоту
        let bottomPadding = window.safeAreaInsets.bottom
        boardView.frame.size.height = UIScreen.main.bounds.height - boardView.frame.origin.y - margin - bottomPadding
        
        // Изменяем стиль игрового поля
        boardView.layer.cornerRadius = 5
        boardView.layer.backgroundColor = #colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1)
        
        return boardView
    }
    
    // MARK: Размер и расположение карточек
    private var cardSize = CGSize(width: 80, height: 120)
    
    private var cardMaxXCoordinate: Int {
        Int(boardGameView.frame.width - cardSize.width)
    }
    
    private var cardMaxYCoordinate: Int {
        Int(boardGameView.frame.height - cardSize.height)
    }
    
    
    // MARK: Генерация массива карточек на основе данных Модели
    private func getCardsBy(modelData: [Card]) -> [UIView] {
        var cardViews = [UIView]()
        let cardViewFactory = CardViewFactory()
        
        for(index,cardModel) in modelData.enumerated() {
            let cardOne = cardViewFactory.get(cardModel.type, withSize: cardSize, andColor: cardModel.color)
            cardOne.tag = index
            cardViews.append(cardOne)
            
            let cardTwo = cardViewFactory.get(cardModel.type, withSize: cardSize, andColor: cardModel.color)
            cardTwo.tag = index
            cardViews.append(cardTwo)
        }
        
        // добавляем всем картам обработчик переворота
        
        for card in cardViews {
            (card as! FlippableView).flipCompletionHandler = { [self] flippedCard in
                flippedCard.superview?.bringSubviewToFront(flippedCard)
                if flippedCard.isFlipped {
                    self.flippedCards.append(flippedCard)
                } else {
                    if let cardIndex = self.flippedCards.firstIndex(of: flippedCard) {
                        self.flippedCards.remove(at: cardIndex)
                    }
                }
                
                if self.flippedCards.count == 2 {
                    let firstCard = game.cards[self.flippedCards.first!.tag]
                    let secondCard = game.cards[self.flippedCards.last!.tag]
                    
                    if game.checkCards(firstCard, secondCard) {
                        //анимировано скрываем карточки
                        UIView.animate(withDuration: 0.3, animations: {
                            self.flippedCards.first!.layer.opacity = 0
                            self.flippedCards.last!.layer.opacity = 0
                        }, completion: { _ in
                            self.flippedCards.first?.removeFromSuperview()
                            self.flippedCards.last?.removeFromSuperview()
                            self.flippedCards = []
                        })
                    } else {
                        for card in self.flippedCards {
                            (card as! FlippableView).flip()
                        }
                    }
                }
            }
        }
        return cardViews
    }
    
    // массив перевернутых карточек
    private var flippedCards = [UIView]()
    
    var cardViews = [UIView]()
    
    private func placeCardsOnBoard(_ cards: [UIView]) {
        // удаляем все карточки с поля
        for card in cardViews {
            card.removeFromSuperview()
        }
        cardViews = cards
        // перебираем карточки
        for card in cardViews {
            let randomXCoordinate = Int.random(in: 0...cardMaxXCoordinate)
            let randomYCoordinate = Int.random(in: 0...cardMaxYCoordinate)
            card.frame.origin = CGPoint(x: randomXCoordinate, y: randomYCoordinate)
            boardGameView.addSubview(card)
        }
    }
}
