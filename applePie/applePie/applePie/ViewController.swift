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
    
    @IBOutlet weak var theFirstWordSaved: UILabel!
    
    
    var listOfWords = ["apple","bread","cake"] //["buccaneer", "swift", "glorious", "incandescent", "bug", "program"]
   
    var replayList = Array<String>()

 
    
 
    let incorrectMoveAllowed = 7

    var totalWins = 0 {
        didSet {
            checkAndShowResultPopup(isWin: true)
            newRound()
        }
    }
    var totalLoses = 0 {
        didSet {
            checkAndShowResultPopup(isWin: false)
            newRound()
        }
    }

    var currentGame:Game!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        newRound()/////뉴라운드 실행
        
        // Do any additional setup after loading the view.
    }
    
    func saveTheFirstWord(newWord: String) {
        replayList.append(newWord) // 되돌아가기를 위해서, 꺼낸 아이를 담아둔다.
        
//        var theFirstWord :String?
//        theFirstWord = "\(String(describing: listOfWords.first))"
//
//        if let theWord = theFirstWord {
//            print(theWord)
//        }
    }

   
    
    func newRound() {//뉴라운드 동작
        
        if !listOfWords.isEmpty {
            let newWord = listOfWords.removeFirst()//첫번째것을 꺼내면서 어레이에서는 삭제//
            
            saveTheFirstWord(newWord: newWord)
            
//            manager.registerUndo(withTarget: listOfWords) { $0.add(word) }
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
    
    func replayRound() {//replay라운드 동작
        if let l = self.replayList.popLast() {
            self.listOfWords.insert(l, at: 0) // 앞에다가 팝된 아이를 다시 붙여준다.
        }
        if let l = self.replayList.popLast() {
            self.listOfWords.insert(l, at: 0) // 앞에다가 팝된 아이를 다시 붙여준다.
        }

        newRound()
//        if !listOfWords.isEmpty {
//            let newWord = listOfWords.removeFirst()
//
//            currentGame = Game(word: newWord, incorrectMovesRemaining: incorrectMoveAllowed, guessedLetters:[])
//            //현재게임을 게임스트럭쳐로 초기화함.뉴워드를 주고 7이라고 정의된 인코랙트무브어라우드 값으로 7번의 기회를 가지는 새로운 게임이 완성됨
//            updateUI()
//            enabledLetterButtons(true)
//            //모든 켜는 함수
//
//        } else {
//            enabledLetterButtons(false)
//            //모든 끄는 함수
//        }
    }

    
    func updateUI() {
        var letters = [String]()
        for letter in currentGame.formattedWord {
            letters.append(String(letter))
        }
        
        let wordWithSpacing = letters.joined(separator: " ")
        
        theFirstWordSaved.text = replayList.last
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
//        checkAndShowResultPopup()
    }
    
    
    /// 결과를 확인해서, 팝업을 띄운다.
    func checkAndShowResultPopup(isWin: Bool) {
        var title = ""
        var message = ""
        
        if listOfWords.isEmpty == true { /// 전체 게임이 끝났음.
            title = "게임 끄읏~!"
            message = "승: \(totalWins), 패: \(totalLoses)"
        }
        else { /// 각 게임이 끝났음.
            if isWin == true {
                title = "이겼음!!!!"
                message = "앞으로 \(listOfWords.count)번 남았음!"
            }
            else {
                title = "졌다..ㅠ.ㅜ"
                message = "남은 기회는 \(listOfWords.count)번 뿐.. ㅠ.ㅜ"
            }
        }
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        
        let okAction = UIAlertAction(title: "확인", style: .default)
        let resetAction = UIAlertAction(title: "다시 도전", style: .cancel)
        { [self]action in
            self.replayRound()
        }
        
        
        alert.addAction(resetAction)
        alert.addAction(okAction)

        self.present(alert, animated: true, completion: nil)
        
//        alert.addAction(UIAlertAction(title: "확인", style: .default))
//        alert.addAction(UIAlertAction(title: "다시 도전", style: .cancel))
//
//        self.present(alert, animated: true)
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

