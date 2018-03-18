//
//  ViewController.swift
//  Set
//
//  Created by Alon Shprung on 3/13/18.
//  Copyright © 2018 Alon Shprung. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    private lazy var game = SetGame()
    
    private var isMatchOnScreen = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        updateViewFromModel()
    }
    
    @IBOutlet weak var scoreLable: UILabel!
    
    @IBOutlet var cardButtons: [UIButton]!
    
    @IBAction func startNewGame(_ sender: UIButton) {
        game.newGame()
        updateViewFromModel()
    }
    
    @IBAction func touchCard(_ sender: UIButton) {
        guard let cardNumber = cardButtons.index(of: sender) else {
            print("choosen card was not in cardButtons")
            return
        }
        guard cardNumber < game.cardsBeingPlayed.count else {
            return
        }
        

        game.chooseCard(at: cardNumber)
        
        updateViewFromModel()
        
        // check if game is finished
        if (game.alreadyMatchedCards.count == 81){
            showAlertWhenGameFinished()
        }
    }
    
    @IBAction func dealThreeMoreCards(_ sender: UIButton) {
        isMatchOnScreen = false
        game.dealThreeMoreCards()
        updateViewFromModel()
    }
    
    
    @IBOutlet weak var DealThreeMoreCardsButton: UIButton!
    
    private func showCardTitle(_ card: Card, _ button: UIButton) {
        let stringAttributes = getNSAttributedStringKeyForShadingAndColor(card: card)
        let buttonTitle = getButtonTitle(card: card)
        let AttrString = NSAttributedString(string: buttonTitle, attributes: stringAttributes)
            
        button.setAttributedTitle(AttrString, for: UIControlState.normal)
    }
    
    private func showCardSelection(_ card: Card, _ button: UIButton) {
        if card.isSelected {
            button.layer.borderWidth = 3.0
            button.layer.borderColor = UIColor.blue.cgColor
        } else {
            button.layer.borderWidth = 0
        }
    }
    
    private func isCardAppearOnScreen(_ card: Card, _ button: UIButton) -> Bool {
        if card.isAppearOnScreen {
            return true
        } else {
            hiddenCardButtonFromScreen(button)
            return false
        }
    }
    
    private func hiddenCardButtonFromScreen(_ button: UIButton){
        button.layer.borderWidth = 0
        button.backgroundColor = #colorLiteral(red: 0.675611496, green: 0.7385349274, blue: 1, alpha: 0)
        button.setAttributedTitle(NSAttributedString(string: ""), for: UIControlState.normal)
    }
    
    private func showCardMatching(_ card: Card, _ button: UIButton) {
        if card.isMatch {
            button.layer.borderWidth = 3.0
            button.layer.borderColor = UIColor.green.cgColor
            isMatchOnScreen = true
        } else if game.selectedCardsIndex.count == 3, card.isSelected {
            button.layer.borderWidth = 3.0
            button.layer.borderColor = UIColor.red.cgColor
            isMatchOnScreen = false
        }
    }
    
    private func updateViewFromModel() {
        for index in cardButtons.indices {
            let button = cardButtons[index]
            guard index < game.cardsBeingPlayed.count else {
                hiddenCardButtonFromScreen(button)
                continue
            }
            let card = game.cardsBeingPlayed[index]
            if isCardAppearOnScreen(card, button) {
                button.backgroundColor = #colorLiteral(red: 0.675611496, green: 0.7385349274, blue: 1, alpha: 1)
                showCardSelection(card, button)
                showCardMatching(card, button)
                showCardTitle(card, button)
            }
        }
        // update score lable
        scoreLable.text = "Score: \(game.score)"
        
        updateDealThreeMoreCardsButton()
    }
    
    private func updateDealThreeMoreCardsButton() {
        if isMatchOnScreen, !game.deck.isNoMoreCardsInDeck() {
            DealThreeMoreCardsButton.isEnabled = true
        } else if game.cardsBeingPlayed.count == 24 || game.deck.isNoMoreCardsInDeck() {
            DealThreeMoreCardsButton.isEnabled = false
        } else {
            DealThreeMoreCardsButton.isEnabled = true
        }
    }
    
    private func getButtonTitle(card: Card) -> String {
        var symbol = getSymbol(card: card)
        switch card.number {
        case .one:
            break
        case .two:
            symbol = symbol + " " + symbol
        case .three:
            symbol = symbol + " " + symbol + " " + symbol
        }
        return symbol
    }
    
    private func getSymbol(card: Card) -> String {
        let symbols = ["■","●","▲"]
        switch card.symbol {
        case .symbol0:
            return symbols[0]
        case .symbol1:
            return symbols[1]
        case .symbol2:
            return symbols[2]
        }
    }
    
    private func getCardColor(card: Card) -> UIColor {
        let colors = [#colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1),#colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1),#colorLiteral(red: 0.1764705926, green: 0.01176470611, blue: 0.5607843399, alpha: 1)]
        switch card.color {
        case .color0:
            return colors[0]
        case .color1:
            return colors[1]
        case .color2:
            return colors[2]
        }
    }
    
    private func getNSAttributedStringKeyForShadingAndColor(card: Card) -> [NSAttributedStringKey : Any] {
        let cardColor = getCardColor(card: card)

        switch card.shading {
        case .striped:
            return [NSAttributedStringKey.foregroundColor: cardColor.withAlphaComponent(0.15)]
        case .filled:
            return [NSAttributedStringKey.foregroundColor: cardColor.withAlphaComponent(1), NSAttributedStringKey.strokeWidth: -1]
        case .outline:
            return [NSAttributedStringKey.foregroundColor: cardColor.withAlphaComponent(1), NSAttributedStringKey.strokeWidth: 4]
        }
    }
    
    private func showAlertWhenGameFinished() {
        // create the alert
        let alert = UIAlertController(title: "Congratulations!", message: "Your Final Score: \(game.score)", preferredStyle: UIAlertControllerStyle.alert)
        
        // add an action (button)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil))
        
        // show the alert
        self.present(alert, animated: true, completion: nil)
    }
}

