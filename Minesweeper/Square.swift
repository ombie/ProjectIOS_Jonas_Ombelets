import Foundation

class Square {
    let xCo:Int
    let yCo:Int
    
    // default values of each new game
    var numNeighboringMines = 0     // number of adjacent squares which contains a mine
    var isMineLocation = false      // boolean: square contains mine
    var hasNoNeighborMines = false  // boolean: square has no neighbors with mines
    var isRevealed = false          // boolean: isClicked
    
    var neighbors:[Square] = []     // attribute array of Squares: contains square's neighbors
    
    // coördinates of the square
    init(x:Int, y:Int) {
        self.xCo = x
        self.yCo = y
    }
}