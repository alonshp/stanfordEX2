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
    
    private(set) var selectedCardsIndex = [Int]()
    
    mutating func chooseCard(at index: Int) {
        assert(deck.cards.indices.contains(index), "SetGame.chooseCard(at: \(index)) : Choosen index out of range")
        
        if (selectedCardsIndex.count < 3){
            selectOrUnselectCard(at: index)
        } else {
            for i in selectedCardsIndex.indices {
                deck.cards[selectedCardsIndex[i]].isMatch = true
            }
        }

    }
    
    mutating private func selectOrUnselectCard(at index: Int){
        if deck.cards[index].isSelected {
            deck.cards[index].isSelected = false
            for i in selectedCardsIndex.indices {
                if selectedCardsIndex[i] == index {
                    selectedCardsIndex.remove(at: i)
                }
            }
        } else {
            deck.cards[index].isSelected = true
            selectedCardsIndex.append(index)
        }
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
