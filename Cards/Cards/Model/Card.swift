//
//  Card.swift
//  Cards


import UIKit

typealias Card = (type: CardType, color: CardColor)

enum CardType: CaseIterable {
    case circle
    case cross
    case square
    case fill
}

enum CardColor: CaseIterable {
    case red
    case green
    case black
    case gray
    case brown
    case yellow
    case purple
    case orange
}
