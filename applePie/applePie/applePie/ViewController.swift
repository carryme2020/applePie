//
//  ViewController.swift
//  applePie
//
//  Created by Kyunghyun Lee on 2023/02/17.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var treeImageView: UIImageView!
    
    @IBOutlet weak var correctWordLabel: UILabel!
    
    @IBOutlet weak var scoreLabel: UILabel!
    
    
    @IBOutlet var letterButtons: [UIButton]!
    
    var listOfWords = ["buccaneer", "swift", "glorious", "incandescent", "bug", "program"]
    let incorrectMoveAllowed = 7
    
    var totalWins = 0 {
        didSet {
            newRound()
        }
    }
    var totalLoses = 0 {
        didSet {
            newRound()
        }
    }
    
    var currentGame:Game!  //
    
    override func viewDidLoad() {
        super.viewDidLoad()
        newRound()/////뉴라운드 실행
        
        // Do any additional setup after loading the view.
    }

    func newRound() {//뉴라운드 동작
        if !listOfWords.isEmpty {
            let newWord = listOfWords.removeFirst()//첫번째것을 꺼내면서 어레이에서는 삭제//
            currentGame = Game(word: newWord, incorrectMovesRemaining: incorrectMoveAllowed, guessedLetters:[])
            //현재게임을 게임스트럭쳐로 초기화함.뉴워드를 주고 7이라고 정의된 인코랙트무브어라우드 값으로 7번의 기회를 가지는 새로운 게임이 완성됨
            updateUI()
            enabledLetterButtons(true)
            //모든 켜는 함수
            
        } else {
            enabledLetterButtons(false)
            //모든 끄는 함수
        }
    }
    
    func updateUI() {
        var letters = [String]()
        for letter in currentGame.formattedWord {
            letters.append(String(letter))
        }
        
        let wordWithSpacing = letters.joined(separator: " ")
        
        correctWordLabel.text = wordWithSpacing //currentGame.formattedWord
        scoreLabel.text = "Wins: \(totalWins), Loses: \(totalLoses)"
        treeImageView.image = UIImage(named: "Tree \(currentGame.incorrectMovesRemaining)")
    }
    
    @IBAction func buttonTapped(_ sender: UIButton) {
        sender.isEnabled = false
        let letterString = sender.title(for: .normal)!
        let letter = Character(letterString.lowercased())
        currentGame.playerGuessed(letter: letter)
        updateGameState()//updateUI()
    }
    
    func updateGameState() {
        if currentGame.incorrectMovesRemaining == 0 {
           totalLoses += 1
        } else if currentGame.word == currentGame.formattedWord {
            totalWins += 1
        } else {
            updateUI()
        }
        
    }
    
    func enabledLetterButtons(_ enable:Bool) {
        for button in letterButtons {
            button.isEnabled = enable
        }
    }


}

