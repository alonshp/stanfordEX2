//
//  Set.swift
//  Set
//
//  Created by Alon Shprung on 3/15/18.
//  Copyright © 2018 Alon Shprung. All rights reserved.
//

import Foundation

public struct SetGame {
    
    var deck = Deck()
    var cardsBeingPlayed = [Card]()
    
    private(set) var selectedCardsIndex = Set<Int>()
    private(set) var alreadyMatchedCards = [Card]()
    
    mutating func chooseCard(at index: Int) {
        assert(cardsBeingPlayed.indices.contains(index), "SetGame.chooseCard(at: \(index)) : Choosen index out of range")
        
        switch selectedCardsIndex.count {
        case 2:
            selectOrUnselectCard(at: index)
            if selectedCardsIndex.count == 3{
                if checkIfSelectedCardsAreMatch() {
                    for cardIndex in selectedCardsIndex {
                        cardsBeingPlayed[cardIndex].isMatch = true
                        
                    }
                } else {
                    
                }
            }
        case 3:
            var anotherCardSelected = false
            if !selectedCardsIndex.contains(index){
                anotherCardSelected = true
            }
            for cardIndex in selectedCardsIndex {
                cardsBeingPlayed[cardIndex].isSelected = false
                cardsBeingPlayed[cardIndex] = deck.takeAcard()!
            }
            selectedCardsIndex = Set<Int>()
            if anotherCardSelected {
                selectOrUnselectCard(at: index)
            }
        default:
            selectOrUnselectCard(at: index)
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
    
    private func checkIfSelectedCardsAreMatch() -> Bool{
        var selectedCards = [Card]()
        for index in selectedCardsIndex {
            let currCard = cardsBeingPlayed[index]
            selectedCards.append(currCard)
        }
        return isCardsMatch(cards: selectedCards)
    }
    
    public func isCardsMatch(cards: [Card]) -> Bool{
        var cardsColor = Set<Card.Color>()
        var cardsShading = Set<Card.Shading>()
        var cardsNumber = Set<Card.Number>()
        var cardsSymbol = Set<Card.Symbol>()
        
        for currCard in cards {
            cardsColor.insert(currCard.color)
            cardsSymbol.insert(currCard.symbol)
            cardsNumber.insert(currCard.number)
            cardsShading.insert(currCard.shading)
        }
        
        if (cardsColor.count == 1 || cardsColor.count == Card.Color.all.count)
            && (cardsShading.count == 1 || cardsShading.count == Card.Shading.all.count)
            && (cardsNumber.count == 1 || cardsNumber.count == Card.Number.all.count)
            && (cardsSymbol.count == 1 || cardsSymbol.count == Card.Symbol.all.count) {
            return true
        } else {
            return false
        }
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
