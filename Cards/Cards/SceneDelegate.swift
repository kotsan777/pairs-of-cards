//
//  SceneDelegate.swift
//  Cards
//
//  Created by Аслан Кутумбаев on 19.10.2021.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else {
            return
        }
        let game = Game(cardPairs: 3)
        let cardViewFactory = CardViewFactory(cardSize: CGSize(width: 70, height: 140))
        let boardGameView = BoardGameView()
        let startButtonView = StartButton()
        let boardGameConstructor = BoardGameConstructor(game: game, cardViewFactory: cardViewFactory, boardGameView: boardGameView, startButton: startButtonView)
        let boardGameController = BoardGameController(boardGameConstructor: boardGameConstructor)
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.windowScene = windowScene
        window.rootViewController = boardGameController
        window.makeKeyAndVisible()
        self.window = window
    }
    
}

