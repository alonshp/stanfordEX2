//
//  NewViewController.swift
//  SetGame
//
//  Created by Alon Shprung on 3/20/18.
//  Copyright © 2018 Alon Shprung. All rights reserved.
//

import UIKit

class NewViewController: UIViewController {

    @IBOutlet weak var boardView: UIView!
    
    private lazy var game = SetGame()
    
    private var cardViews = [CardView]()
    
    private var isMatchOnScreen = false
    
    private var wasMatchOnScreenOnLastMoveWhenDeckIsEmpty = false
    
    private var matchCardViewsOnLastMoveWhenDeckIsEmpty = [CardView]()
    
    private var matchCardViewsOnScreen = [CardView]()
    
    private var rotationGesture: UIRotationGestureRecognizer?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        for _ in 0..<12 {
            addCardView()
        }
        
        // swipe down for deal 3 more cards
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(self.dealThreeMoreCards(_:)))
        swipeDown.direction = .down
        self.view.addGestureRecognizer(swipeDown)
        
        // rotation gesture to cause all the cards to randomly reshuffle
        rotationGesture = UIRotationGestureRecognizer(target: self, action: #selector(self.shuffleCards(_:)))
        self.view.addGestureRecognizer(rotationGesture!)
    }

    override func viewDidLayoutSubviews() {
        updateViewFromModel()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func shuffleCards(_ sender: UIRotationGestureRecognizer) {
        switch rotationGesture!.state {
        case UIGestureRecognizerState.ended:
            game.shuffleCardsBiengPlayed()
            updateViewFromModel()
        default:
            break
        }

    }
    
    @objc func dealThreeMoreCards(_ sender: UISwipeGestureRecognizer) {
        guard !game.deck.isNoMoreCardsInDeck() else {
            return
        }
        game.dealThreeMoreCards()
        for _ in 0..<3 {
            addCardView()
        }
        updateViewFromModel()
    }
    
    private func addCardView(){
        let cardView = CardView()
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        cardView.addGestureRecognizer(tap)
        
        self.view.addSubview(cardView)
        cardViews.append(cardView)
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        guard let cardNumber = cardViews.index(of: sender.view as! CardView) else {
            print("choosen card was not in cardButtons")
            return
        }
        game.chooseCard(at: cardNumber)
        updateViewFromModel()
    }
    
    private func updateViewFromModel() {
        let numberOfCards = game.cardsBeingPlayed.count
        let newGrid = getNewGrid(numberOfCards: numberOfCards)
        isMatchOnScreen = false
        matchCardViewsOnScreen = [CardView]()
        for index in game.cardsBeingPlayed.indices {
            let card = game.cardsBeingPlayed[index]
            let cardView = cardViews[index]
            cardView.cardLable.attributedText = getCardAttrString(card)
            cardView.frame = newGrid[index]!
            showCardSelection(card, cardView)
            showCardMatching(card, cardView)
        }
        if wasMatchOnScreenOnLastMoveWhenDeckIsEmpty {
            wasMatchOnScreenOnLastMoveWhenDeckIsEmpty = false
            for cardView in matchCardViewsOnLastMoveWhenDeckIsEmpty {
                cardView.removeFromSuperview()
            }
        }
        if game.deck.isNoMoreCardsInDeck(), isMatchOnScreen {
            wasMatchOnScreenOnLastMoveWhenDeckIsEmpty = true
            for cardView in matchCardViewsOnScreen {
                cardViews.remove(at: cardViews.index(of: cardView)!)
                matchCardViewsOnLastMoveWhenDeckIsEmpty.append(cardView)
            }
        }
        
    }
    
    private func showCardMatching(_ card: Card, _ cardView: CardView) {
        if card.isMatch {
            cardView.cardInternalView.layer.borderWidth = 3.0
            cardView.cardInternalView.layer.borderColor = UIColor.green.cgColor
            isMatchOnScreen = true
            matchCardViewsOnScreen.append(cardView)
        } else if game.selectedCardsIndex.count == 3, card.isSelected {
            cardView.cardInternalView.layer.borderWidth = 3.0
            cardView.cardInternalView.layer.borderColor = UIColor.red.cgColor
            isMatchOnScreen = false
        }
    }
    
    private func getNewGrid(numberOfCards: Int) -> Grid {
        return Grid(layout: Grid.Layout.dimensions(rowCount: numberOfCards / 3, columnCount:  3), frame: boardView.frame)
    }
    
    private func showCardSelection(_ card: Card, _ cardView: CardView) {
        if card.isSelected {
            cardView.cardInternalView.layer.borderWidth = 3.0
            cardView.cardInternalView.layer.borderColor = UIColor.blue.cgColor
        } else {
            cardView.cardInternalView.layer.borderWidth = 0
        }
    }
    
    
    private func getCardAttrString(_ card: Card) -> NSAttributedString {
        let stringAttributes = getNSAttributedStringKeyForShadingAndColor(card: card)
        let buttonTitle = getButtonTitle(card: card)
        return NSAttributedString(string: buttonTitle, attributes: stringAttributes)
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



}
