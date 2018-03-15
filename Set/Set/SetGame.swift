//
//  Set.swift
//  Set
//
//  Created by Alon Shprung on 3/15/18.
//  Copyright © 2018 Alon Shprung. All rights reserved.
//

import Foundation

struct SetGame {
    
    var deck = Deck()
    var cardsBeingPlayed = [Card]()
    
    private(set) var selectedCardsIndex = Set<Int>()
    private(set) var alreadyMatchedCards = [Card]()
    
    mutating func chooseCard(at index: Int) {
        assert(cardsBeingPlayed.indices.contains(index), "SetGame.chooseCard(at: \(index)) : Choosen index out of range")
        
        if (selectedCardsIndex.count < 3){
            selectOrUnselectCard(at: index)
        } else {
            for i in selectedCardsIndex.indices {
                cardsBeingPlayed[selectedCardsIndex[i]].isMatch = true
            }
        }

    }
    
    mutating private func selectOrUnselectCard(at index: Int){
        if cardsBeingPlayed[index].isSelected {
            cardsBeingPlayed[index].isSelected = false
            selectedCardsIndex.remove(index)
        } else {
            cardsBeingPlayed[index].isSelected = true
            selectedCardsIndex.insert(index)
        }
    }
    
    private func checkIfSelectedCardsAreMatch(){
        
    }
    
    mutating func newGame(){
        deck = Deck()
        cardsBeingPlayed = [Card]()
        selectedCardsIndex = Set<Int>()
        alreadyMatchedCards = [Card]()
        takeCardsFromDeck(numberOfCards: 12)
    }
    
    mutating private func takeCardsFromDeck(numberOfCards: Int){
        for _ in 1...numberOfCards {
            if let card = deck.takeAcard() {
                cardsBeingPlayed.append(card)
            } else {
                print("No more cards in deck")
            }
        }
    }
    
    init() {
        takeCardsFromDeck(numberOfCards: 12)
    }
}


extension Int {
    var arc4random: Int {
        if self > 0 {
            return Int(arc4random_uniform(UInt32(self))) }
        else if self < 0 {
            return -Int(arc4random_uniform(UInt32(abs(self))))
        } else {
            return 0
        }
    }
}
