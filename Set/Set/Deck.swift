//
//  Deck.swift
//  Set
//
//  Created by Alon Shprung on 3/15/18.
//  Copyright © 2018 Alon Shprung. All rights reserved.
//

import Foundation

public struct Deck {
    
    private var cards = [Card]()
    
    init() {
        for symbol in Card.Symbol.all {
            for number in Card.Number.all {
                for color in Card.Color.all {
                    for shading in Card.Shading.all {
                        cards.append(Card(symbol: symbol, number: number, shading: shading, color: color))
                    }
                }
            }
        }
        
        shuffleCards()
    }
    
    mutating func takeAcard() -> Card? {
        if cards.isEmpty {
            return nil
        }
        return cards.remove(at: 0)
    }
    
    mutating func shuffleCards(){
        var shuffeled = [Card]()
        while !cards.isEmpty {
            shuffeled.append(cards.remove(at: cards.count.arc4random))
        }
        cards = shuffeled
    }
}
