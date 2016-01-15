import Foundation

class Gameboard{
    let size:Int
    let numberOfMines:Int
    var squares:[[Square]] = [] // 2nd array, indexed by [xCo][yCo] (= [col][row]
    
    let NUMBER_MINES_BEGINNER = 10
    let NUMBER_MINES_ADVANCED = 40
    
    // array which contains the squares with a mine
    var minesArray:[Square] = []
    
    init(size:Int) {
        self.size = size
        
        switch(size) {
        case 9:
            self.numberOfMines = 10
            break
        default:
            self.numberOfMines = 0
            break
        }
        
        for col in 0 ..< size {
            var squareCol:[Square] = []
            for row in 0 ..< size {
                let square = Square(x: col, y: row)
                squareCol.append(square)
            }
            squares.append(squareCol)
        }
    }
    
    func resetGameboard() {
        // assign mines to squares
        for col in 0 ..< size {
            for row in 0 ..< size {
                squares[col][row].isMineLocation = false
                squares[col][row].hasNoNeighborMines = false
                squares[col][row].isRevealed = false
                //self.calculateIsMineLocationForSquare(squares[col][row])
            }
        }
        minesArray = []
        createMines()
        
        // count number of neighboring squares
        for col in 0 ..< size {
            for row in 0 ..< size {
                self.calculateNumNeighborMinesForSquare(squares[col][row])
            }
        }
    }
    
    func createMines() {
        var mines = numberOfMines
        
        while(mines > 0) {
            let randomX = Int(arc4random_uniform(9)) // number from 0-8
            let randomY = Int(arc4random_uniform(9))
            let newMine:Square = squares[randomX][randomY]
            
            if(!newMine.isMineLocation){
                newMine.isMineLocation = true
                mines--
                minesArray.append(newMine)
            }
        }
    }
    
    // assign mine to square (10% probability)
    /*func calculateIsMineLocationForSquare(square: Square) {
        square.isMineLocation = ((arc4random()%10) == 0) // chance of 1-10 that square contains mine
    }*/
    
    
    // get the number of squares that contain a mine for a specific square sq
    func calculateNumNeighborMinesForSquare(sq : Square) {
        // get a list of adjacent squares (= neighbors)
        let neighbors = getNeighboringSquares(sq)
        
        var numNeighboringMines = 0
        
        // for each neighbor with a mine, add 1 to this square's minecount
        for neighborSquare in neighbors {
            if neighborSquare.isMineLocation {
                // numNeighboringMines += numNeighboringMines doesn't work
                numNeighboringMines++
            }
        }
        sq.numNeighboringMines = numNeighboringMines
        
        if(sq.numNeighboringMines == 0) {
            sq.hasNoNeighborMines = true;
        }
    }
    
    // get neighbors for square sq
    func getNeighboringSquares(sq : Square) -> [Square] {
        var neighbors:[Square] = []
        
        // array of tuples
        // relative position of each neighbor to square sq
        // sq(0,0)
        let adjacentOffsets =
        [(-1,-1),(0,-1),(1,-1),
            (-1,0),(1,0),
            (-1,1),(0,1),(1,1)]
        
        for (xOffset,yOffset) in adjacentOffsets {
            // getTileAtLocation can be nil or a Square => optional datatype "?"
            let optionalNeighbor:Square? = getTileAtLocation(sq.xCo+xOffset, y: sq.yCo+yOffset)
            
            // append when optionalNeighbor isn't nil
            if let neighbor = optionalNeighbor {
                neighbors.append(neighbor)
            }
        }
        sq.neighbors = neighbors
        return neighbors
    }
    
    
    // get square at specific location
    func getTileAtLocation(x : Int, y : Int) -> Square? {
        if x >= 0 && x < self.size && y >= 0 && y < self.size {
            return squares[x][y]
        } else {
            return nil
        }
    }
}