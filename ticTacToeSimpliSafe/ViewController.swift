//
//  ViewController.swift
//  ticTacToeSimpliSafe
//
//  Created by Dominick Hera on 7/15/19.
//  Copyright © 2019 Dominick Hera. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var newGameButton: UIButton!
    @IBOutlet weak var currentPlayerTurnImageView: UIImageView!
    @IBOutlet weak var winnerTextLabel: UILabel!

    var boardMoves = [[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0]]
    var XPlayerTurn: Bool = true
    override func viewDidLoad() {
        super.viewDidLoad()
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        layout.itemSize = CGSize(width: 85, height: 85)
        layout.minimumInteritemSpacing = 1
        layout.minimumLineSpacing = 1
        
        collectionView!.collectionViewLayout = layout
        collectionView.layer.borderWidth = 1.0
        collectionView.layer.borderColor = UIColor.darkGray.cgColor
        collectionView.layer.shadowColor = UIColor.black.cgColor
        collectionView.layer.shadowOpacity = 0.16
        collectionView.layer.shadowOffset = CGSize(width: 0, height: 1)
        collectionView.layer.masksToBounds = false
        newGameButton.layer.cornerRadius = 10
        newGameButton.layer.shadowOpacity = 0.16
        newGameButton.layer.shadowOffset = CGSize(width: 0, height: 1)
        newGameButton.layer.masksToBounds = false
        // Do any additional setup after loading the view.
    }
    
    func setCurrentPlayerTurn() {
        if(XPlayerTurn) {
            checkWin(playerNum: 2)
            currentPlayerTurnImageView.image = UIImage(named: "X.png")
        } else {
            checkWin(playerNum: 1)
            currentPlayerTurnImageView.image = UIImage(named: "O.png")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let cell = collectionView.cellForItem(at: indexPath) as! CollectionViewCell
        if(XPlayerTurn) {
            XPlayerTurn = false
            boardMoves[indexPath.section][indexPath.item] = 1
            checkWin(playerNum: 2)
            cell.cellImageView.image = UIImage(named: "X.png")
        } else {
            XPlayerTurn = true
            boardMoves[indexPath.section][indexPath.item] = 2
            checkWin(playerNum: 1)
            cell.cellImageView.image = UIImage(named: "O.png")
        }
        setCurrentPlayerTurn()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 4
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CollectionViewCell
        cell.cellImageView.image = nil
        cell.backgroundColor = UIColor.white
        
        return cell
    }
    
    func checkWinCondtion(s1: Int, s2: Int, s3: Int, s4: Int, playerNum: Int) -> Bool{
        if(s1 == playerNum && s2 == playerNum && s3 == playerNum && s4 == playerNum) {
            return true
        }
        
        return false
    }
    
    func checkTieCondition() -> Bool{
        for i in 0...3 {
            for k in 0...3 {
                if (boardMoves[i][k] == 0) {
                    return false
                }
            }
        }
        return true
    }
    
    func showWinCell(x: Int, y: Int) {
        let tempIndexPath = IndexPath(row: y, section: x)
        let cell = collectionView.cellForItem(at: tempIndexPath) as! CollectionViewCell
        cell.backgroundColor = UIColor.green
    }
    
    func checkWin(playerNum: Int){
        for i in 0...3 {
            if (checkWinCondtion(s1: boardMoves[i][0], s2: boardMoves[i][1], s3: boardMoves[i][2], s4: boardMoves[i][3], playerNum: playerNum)) {
                showWinCell(x: i, y: 0)
                showWinCell(x: i, y: 1)
                showWinCell(x: i, y: 2)
                showWinCell(x: i, y: 3)
                processWin(playerNum: playerNum)
            }
        }
        
        for i in 0...3 {
            if (checkWinCondtion(s1: boardMoves[0][i], s2: boardMoves[1][i], s3: boardMoves[2][i], s4: boardMoves[3][i], playerNum: playerNum)) {
                showWinCell(x: 0, y: i)
                showWinCell(x: 1, y: i)
                showWinCell(x: 2, y: i)
                showWinCell(x: 3, y: i)
                processWin(playerNum: playerNum)
            }
        }
        
        if (checkWinCondtion(s1: boardMoves[0][0], s2: boardMoves[1][1], s3: boardMoves[2][2], s4: boardMoves[3][3], playerNum: playerNum)) {
            processWin(playerNum: playerNum)
            showWinCell(x: 0, y: 0)
            showWinCell(x: 1, y: 1)
            showWinCell(x: 2, y: 2)
            showWinCell(x: 3, y: 3)
            
        }
        
        if (checkWinCondtion(s1: boardMoves[0][3], s2: boardMoves[1][2], s3: boardMoves[2][1], s4: boardMoves[3][0], playerNum: playerNum)) {
            processWin(playerNum: playerNum)
            showWinCell(x: 0, y: 3)
            showWinCell(x: 1, y: 2)
            showWinCell(x: 2, y: 1)
            showWinCell(x: 3, y: 0)
        }
        
        if (checkTieCondition()) {
            processWin(playerNum: 0)
        }
        
    }
    
    func processWin(playerNum: Int) {
        disableBoard()
        if (playerNum == 1) {
            self.winnerTextLabel.text = "Player X Wins!"
        } else if (playerNum == 2) {
            self.winnerTextLabel.text = "Player O Wins!"
        } else {
            self.winnerTextLabel.text = "Tie, No Winner"
        }
        self.winnerTextLabel.isHidden = false
    }
    
    func disableBoard() {
        collectionView.isUserInteractionEnabled = false
    }
    func resetMoves() {
        boardMoves = [[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0]]
    }
    
    @IBAction func startNewGameAction(_ sender: Any) {
        XPlayerTurn = true
        setCurrentPlayerTurn()
        resetMoves()
        self.winnerTextLabel.isHidden = true
        collectionView.reloadData()
        collectionView.isUserInteractionEnabled = true
    }
    
}

