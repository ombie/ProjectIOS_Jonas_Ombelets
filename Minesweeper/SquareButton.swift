import Foundation
import UIKit

class SquareButton : UIButton {
    
    let squareSize:CGFloat
    //let squareMargin:CGFloat
    
    var square:Square
    
    init(squareModel:Square, squareSize:CGFloat) {
        self.square = squareModel
        self.squareSize = squareSize
        //self.squareMargin = squareMargin
        
        let x = CGFloat(self.square.xCo) * (squareSize)// + squareMargin)
        let y = CGFloat(self.square.yCo) * (squareSize)// + squareMargin)
        let squareFrame = CGRectMake(x, y, squareSize, squareSize)
        
        super.init(frame: squareFrame)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func getLabelText() -> String {
        if(!self.square.isMineLocation) {
            if square.numNeighboringMines == 0 {
                // there are no tiles next to this tile with mines
                return ""
            } else {
                return "\(self.square.numNeighboringMines)"
            }
        }
        // square is a Mine
        return "M"
    }
}