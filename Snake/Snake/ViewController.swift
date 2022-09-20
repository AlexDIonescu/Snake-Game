//
//  ViewController.swift
//  Snake
//
//  Created by Alex Ionescu on 31.08.2022.
//

import UIKit
import AVFoundation


class ViewController: UIViewController, UpdateText, AlertShow, SnakeSound {
    
    
    let highestScore = UserDefaults()
    var eatingPlayer : AVAudioPlayer?
    var swipePlayer : AVAudioPlayer?
    var losePlayer : AVAudioPlayer?
    
    func playBiteSound() {
        let source = Bundle.main.path(forResource: "AppleBite cut", ofType: "mp3")
        let url = URL(fileURLWithPath: source!)
        
        do {
            
            eatingPlayer = try AVAudioPlayer(contentsOf: url)
            eatingPlayer?.play()
        }
        catch {
            print("Error")
        }
    }
    
    func playLoseSound() {
        let source = Bundle.main.path(forResource: "Spring Sound", ofType: "mp3")
        let url = URL(fileURLWithPath: source!)
        
        do {
            
            losePlayer = try AVAudioPlayer(contentsOf: url)
            losePlayer?.play()
        }
        catch {
            print("Error")
        }
    }
    
    func playSwipeSound() {
        let source = Bundle.main.path(forResource: "swipe sound", ofType: "mp3")
        let url = URL(fileURLWithPath: source!)
        
        do {
            
            swipePlayer = try AVAudioPlayer(contentsOf: url)
            swipePlayer?.play()
        }
        catch {
            print("Error")
        }
    }
    func alert(boolValue: Bool) {
        if boolValue == true {
            alertShow()
        }
    }
    
    func alertShow() {
        self.alert = UIAlertController(title: "You lose!", message: "", preferredStyle: .alert)
        self.alert.addAction(UIAlertAction(title: "Try again", style: .default, handler: { alert in
            self.foodCountLabel.text = "0"
        }))
        self.present(self.alert, animated: true)
    }
    
    
    func setupText(stringValue: String) {
        foodCountLabel.text = stringValue
        if  Int(stringValue)! > highestScore.value(forKey: "score") as! Int {
            highestScore.setValue(Int(stringValue)!, forKey: "score")
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        foodCountLabel.text = "0"
        if highestScore.value(forKey: "score") == nil {
            highestScore.setValue(Int(0), forKey: "score")
        }
        NotificationCenter.default.addObserver(self, selector: #selector(backgroundAction), name: UIApplication.willResignActiveNotification, object: nil)
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(swipeLeft))
        leftSwipe.direction = .left
        view.addGestureRecognizer(leftSwipe)
        
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(swipeRight))
        rightSwipe.direction = .right
        view.addGestureRecognizer(rightSwipe)
        
        let upSwipe = UISwipeGestureRecognizer(target: self, action: #selector(swipeUp))
        upSwipe.direction = .up
        view.addGestureRecognizer(upSwipe)
        
        let downSwipe = UISwipeGestureRecognizer(target: self, action: #selector(swipeDown))
        downSwipe.direction = .down
        view.addGestureRecognizer(downSwipe)
        
        boardView.delegate = self //aici trebuia setat
        boardView.delegate1 = self
        boardView.soundDelegate = self
    }
    
    var alert = UIAlertController()
    var scoreAlert = UIAlertController()
    var backgroundAlert = UIAlertController()
    @IBOutlet weak var boardView: BoardView!
    @IBOutlet weak var foodCountLabel: UILabel!
    @IBOutlet weak var buttonsSwitchLabel: UILabel!
    @IBOutlet weak var switchOutlet: UISwitch!
    @IBOutlet var buttonsCollection : [UIButton]!
    
    @IBAction func switchTap(_ sender: UISwitch) {
        
        if switchOutlet.isOn {
            buttonsSwitchLabel.text = "Buttons on"
            for button in buttonsCollection {
                button.isHidden = false
            }
        } else {
            buttonsSwitchLabel.text = "Buttons off"
            
            for button in buttonsCollection {
                button.isHidden = true
            }
        }
    }
    
    
    @IBAction func infoButtonTap(_ sender: UIButton) {
        boardView.timer.invalidate()
        scoreAlert = UIAlertController(title: "Highest score", message: "\n\n▶︎ \(highestScore.value(forKey: "score") ?? "") 🍎 ◀︎", preferredStyle: .alert)
        scoreAlert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: {
            _ in
            self.directionCheck()
        }))
        scoreAlert.addAction(UIAlertAction(title: "Reset", style: .destructive, handler: { _ in
            
            let alert = UIAlertController(title: "ARE YOU SURE?", message: "", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "YES", style: .default, handler: {
                _ in
                self.highestScore.setValue(0, forKey: "score")
            }))
            alert.addAction(UIAlertAction(title: "NO", style: .default))
            self.present(alert, animated: true)
        }))
        self.present(scoreAlert, animated: true)
    }
    
    
    @objc func backgroundAction() {
        
        if boardView.timerRunning {
            boardView.timer.invalidate()
            activeGame()
        }
    }
    func activeGame() {
        backgroundAlert = UIAlertController(title: "Game paused", message: "Press RESUME to continue your game", preferredStyle: .alert)
        backgroundAlert.addAction(UIAlertAction(title: "RESUME", style: .default, handler: { _ in
            self.directionCheck()
        }))
        self.present(backgroundAlert, animated: true)
    }
    
    
    func directionCheck() {
        if boardView.direction == "right"{
            swipeRight()
        } else if boardView.direction == "left"{
            swipeLeft()
        } else if boardView.direction == "up"{
            swipeUp()
        } else if boardView.direction == "down"{
            swipeDown()
        }
    }
    
    @objc func swipeLeft(){
        boardView.timer.invalidate()
        boardView.left()
    }
    @objc func swipeRight(){
        boardView.timer.invalidate()
        boardView.right()
    }
    @objc func swipeUp(){
        boardView.timer.invalidate()
        boardView.up()
    }
    @objc func swipeDown(){
        boardView.timer.invalidate()
        boardView.down()
    }
    @IBAction func moveLeft(_ sender: UIButton) {
        boardView.timer.invalidate()
        boardView.left()
        
    }
    
    @IBAction func moveUp(_ sender: UIButton) {
        boardView.timer.invalidate()
        boardView.up()
    }
    
    
    @IBAction func moveDown(_ sender: UIButton) {
        boardView.timer.invalidate()
        boardView.down()
    }
    
    @IBAction func moveRight(_ sender: UIButton) {
        boardView.timer.invalidate()
        boardView.right()
    }
    
}


