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
        game.chooseCard(at: cardNumber)
        
        updateViewFromModel()
    }
    
    private func showCards() {
        for index in cardButtons.indices {
            let button = cardButtons[index]
            let card = game.cardsBeingPlayed[index]
            let stringAttributes = getNSAttributedStringKeyForShadingAndColor(card: card)
            let buttonTitle = getButtonTitle(card: card)
            let AttrString = NSAttributedString(string: buttonTitle, attributes: stringAttributes)
            
            button.setAttributedTitle(AttrString, for: UIControlState.normal)
        }
    }
    
    private func updateViewFromModel() {
        for index in cardButtons.indices {
            let button = cardButtons[index]
            let card = game.cardsBeingPlayed[index]
            
            if card.isSelected {
                button.layer.borderWidth = 3.0
                button.layer.borderColor = UIColor.blue.cgColor
            } else {
                button.layer.borderWidth = 0
            }
            
            if card.isMatch {
                button.layer.borderWidth = 3.0
                button.layer.borderColor = UIColor.green.cgColor
            }
        }
        scoreLable.text = "Score: \(game.score)"
        showCards()
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
    
    private func getNSAttributedStringKeyForShadingAndColor(card: Card) -> [NSAttributedStringKey : Any] {
        let colors = [#colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1),#colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1),#colorLiteral(red: 0.1764705926, green: 0.01176470611, blue: 0.5607843399, alpha: 1)]
        var color: UIColor
        switch card.color {
        case .color0:
            color = colors[0]
        case .color1:
            color = colors[1]
        case .color2:
            color = colors[2]
        }
        switch card.shading {
        case .striped:
            return [NSAttributedStringKey.foregroundColor: color.withAlphaComponent(0.15)]
        case .filled:
            return [NSAttributedStringKey.foregroundColor: color.withAlphaComponent(1), NSAttributedStringKey.strokeWidth: -1]
        case .outline:
            return [NSAttributedStringKey.foregroundColor: color.withAlphaComponent(1), NSAttributedStringKey.strokeWidth: 4]
        }
    }
}

