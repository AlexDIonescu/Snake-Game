//
//  BoardView.swift
//  Snake
//
//  Created by Alex Ionescu on 05.09.2022.
//

import UIKit

protocol UpdateText {
    func setupText(stringValue: String)
}

protocol AlertShow {
    func alert(boolValue: Bool)
}
protocol SnakeSound {
    func playBiteSound()
    func playLoseSound()
    func playSwipeSound()
}
class BoardView: UIView {
    
    
    var delegate: UpdateText?
    var delegate1 : AlertShow?
    var soundDelegate : SnakeSound?
    let vc = ViewController()
    override func draw(_ rect: CGRect) {
        drawGrid()
        var color = 0
        for i in grid {
            if color == 0 {
                #colorLiteral(red: 0.637003541, green: 0.8209306734, blue: 0.2833161354, alpha: 1).setFill()
                color = 1
            } else if color == 1 {
                #colorLiteral(red: 0.665880084, green: 0.8443582654, blue: 0.3156208694, alpha: 1).setFill()
                color = 0
            }
            i.fill()
        }
        if x == 0 {
            snake.append(UIBezierPath(roundedRect: .init(x: 180, y: 330, width: 30, height: 30), byRoundingCorners: .allCorners, cornerRadii: .init(width: 0, height: 0)))
            positions.append("\(xPos)" + " " + "\(yPos)")
            
            x = 1
            food = UIBezierPath(roundedRect: .init(x: Int.random(in: 2...8) * 30, y: Int.random(in: 2...13) * 30, width: 30, height: 30), byRoundingCorners: .allCorners, cornerRadii: .init(width: 15, height: 15))
            if snake[0].bounds.midX == food.bounds.midX && snake[0].bounds.midY == food.bounds.midY {
                food = UIBezierPath(roundedRect: .init(x: Int.random(in: 2...8) * 30, y: Int.random(in: 2...13) * 30, width: 30, height: 30), byRoundingCorners: .allCorners, cornerRadii: .init(width: 15, height: 15))
            }
            
            UIColor.black.setStroke()
            UIColor.white.setFill()
            snake[0].fill()
            UIColor.red.setFill()
            food.fill()
            
        } else {
            UIColor.white.setFill()
            snake[0].fill()
            UIColor.systemBlue.setFill()
            if snake.count != 1 {
                for i in 1...snake.count - 1 {
                    snake[i].fill()
                }
            }
            UIColor.red.setFill()
            food.fill()
        }
    }
    
    
    var x = 0
    var grid : [UIBezierPath] = []
    var timer = Timer()
    var food = UIBezierPath()
    var snake : [UIBezierPath] = []
    var xPos = 180
    var yPos = 330
    var foodCounter = 0
    var direction : String = ""
    var positions : [String] = []
    var timerRunning = false
    func drawGrid() {
        for y in stride(from: 0, to: 600, by: 30){
            for x in stride(from: 0, to: 430, by: 30) {
                grid.append(UIBezierPath(roundedRect: CGRect(x: x, y: y, width: 30, height: 30), byRoundingCorners: .allCorners, cornerRadii: CGSize(width: 0, height: 0)))            }
        }
    }
    func right(){
        self.soundDelegate?.playSwipeSound()
        direction = "right"
        timer = Timer.scheduledTimer(withTimeInterval: 0.35, repeats: true) {
            timer in
            self.xPos += 30
            if CGFloat(self.xPos) == self.frame.width || self.headCollision(){
                self.soundDelegate?.playLoseSound()
                timer.invalidate()
                self.resetGame()
                
            } else {
                self.timerRunning = true
                self.snakeMove()
                self.setNeedsDisplay()
                self.foodCheck()
                
            }
        }
    }
    func left(){
        self.soundDelegate?.playSwipeSound()
        direction = "left"
        timer = Timer.scheduledTimer(withTimeInterval: 0.35, repeats: true) {
            timer in
            self.xPos -= 30
            if CGFloat(self.xPos) == -30 || self.headCollision(){
                self.soundDelegate?.playLoseSound()
                timer.invalidate()
                self.resetGame()
                
            } else {
                self.timerRunning = true
                self.snakeMove()
                self.setNeedsDisplay()
                self.foodCheck()
                
            }
        }
    }
    func up(){
        self.soundDelegate?.playSwipeSound()
        direction = "up"
        timer = Timer.scheduledTimer(withTimeInterval: 0.35, repeats: true) {
            timer in
            self.yPos -= 30
            if CGFloat(self.yPos) == -30 || self.headCollision(){
                self.soundDelegate?.playLoseSound()
                timer.invalidate()
                self.resetGame()
                
            } else {
                self.timerRunning = true
                self.snakeMove()
                self.setNeedsDisplay()
                self.foodCheck()
                
            }
        }
    }
    func down(){
        self.soundDelegate?.playSwipeSound()
        direction = "down"
        timer = Timer.scheduledTimer(withTimeInterval: 0.35, repeats: true) {
            timer in
            self.yPos += 30
            if CGFloat(self.yPos) == self.frame.height || self.headCollision(){
                self.soundDelegate?.playLoseSound()
                timer.invalidate()
                self.resetGame()
            } else {
                self.timerRunning = true
                self.snakeMove()
                
                self.setNeedsDisplay()
                self.foodCheck()
            }
            
        }
    }
    
    
    func foodCheck() {
        if snake[0].bounds.midX == food.bounds.midX && snake[0].bounds.midY == food.bounds.midY {
            self.soundDelegate?.playBiteSound()
            food = UIBezierPath(roundedRect: .init(x: Int.random(in: 2...8) * 30, y: Int.random(in: 2...13) * 30, width: 30, height: 30), byRoundingCorners: .allCorners, cornerRadii: .init(width: 15, height: 15))
            var foodPosition = "\(food.bounds.minX)" + " " + "\(food.bounds.minY)"
            var foodPosition1 = "\(food.bounds.minX + 30)" + " " + "\(food.bounds.minY + 30)"
            var foodPosition2 = "\(food.bounds.minX - 30)" + " " + "\(food.bounds.minY - 30)"
            
            if positions.contains(foodPosition) {
                while positions.contains(foodPosition) || positions.contains(foodPosition1) || positions.contains(foodPosition2){
                    food = UIBezierPath(roundedRect: .init(x: Int.random(in: 2...8) * 30, y: Int.random(in: 2...13) * 30, width: 30, height: 30), byRoundingCorners: .allCorners, cornerRadii: .init(width: 15, height: 15))
                    foodPosition = "\(food.bounds.minX)" + " " + "\(food.bounds.minY)"
                    foodPosition1 = "\(food.bounds.minX + 30)" + " " + "\(food.bounds.minY + 30)"
                    foodPosition2 = "\(food.bounds.minX - 30)" + " " + "\(food.bounds.minY - 30)"
                }
            }
            self.setNeedsDisplay()
            foodCounter += 1
            self.delegate?.setupText(stringValue: String(foodCounter))
            addSnake(dir: direction)
        }
    }
    
    
    func addSnake(dir: String) {
        if dir == "right" {
            snake.append(UIBezierPath(roundedRect: CGRect(x: xPos - 30, y: yPos, width: 30, height: 30), byRoundingCorners: .allCorners, cornerRadii: CGSize(width: 0, height: 0)))
            positions.append("\(xPos - 30)" + " " + "\(yPos)")
        } else if dir == "left" {
            snake.append(UIBezierPath(roundedRect: CGRect(x: xPos + 30, y: yPos, width: 30, height: 30), byRoundingCorners: .allCorners, cornerRadii: CGSize(width: 0, height: 0)))
            positions.append("\(xPos + 30)" + " " + "\(yPos)")
            
        } else if dir == "up" {
            snake.append(UIBezierPath(roundedRect: CGRect(x: xPos, y: yPos + 30, width: 30, height: 30), byRoundingCorners: .allCorners, cornerRadii: CGSize(width: 0, height: 0)))
            positions.append("\(xPos)" + " " + "\(yPos + 30)")
        } else if dir == "down" {
            snake.append(UIBezierPath(roundedRect: CGRect(x: xPos, y: yPos - 30, width: 30, height: 30), byRoundingCorners: .allCorners, cornerRadii: CGSize(width: 0, height: 0)))
            positions.append("\(xPos)" + " " + "\(yPos - 30)")
            
        }
        self.setNeedsDisplay()
    }
    
    func snakeMove() {
        var xAux = self.snake[0].bounds.minX
        var yAux = self.snake[0].bounds.minY
        self.snake[0] = UIBezierPath(roundedRect: .init(x: self.xPos, y: self.yPos, width: 30, height: 30), byRoundingCorners: .allCorners, cornerRadii: .init(width: 0, height: 0))
        if self.snake.count != 1 {
            var xAux1 = self.snake[1].bounds.minX
            var yAux1 = self.snake[1].bounds.minY
            for i in 1...self.snake.count - 1 {
                xAux1 = self.snake[i].bounds.minX
                yAux1 = self.snake[i].bounds.minY
                self.snake[i] = UIBezierPath(roundedRect: .init(x: xAux, y: yAux, width: 30, height: 30), byRoundingCorners: .allCorners, cornerRadii: .init(width: 0, height: 0))
                positions[i] = "\(xAux)" + " " + "\(yAux)"
                xAux = xAux1
                yAux = yAux1
            }
        }
    }
    
    func resetGame() {
        delegate1?.alert(boolValue: true)
        x = 0
        xPos = 180
        yPos = 330
        foodCounter = 0
        snake = []
        positions = []
        timerRunning = false
        self.setNeedsDisplay()
    }
    
    func headCollision() -> Bool {
        let headPosition = "\(snake[0].bounds.minX)" + " " + "\(snake[0].bounds.minY)"
        if positions.contains(headPosition) {
            return true
        }
        return false
    }
}
