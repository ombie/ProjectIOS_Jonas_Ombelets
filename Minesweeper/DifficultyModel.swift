import UIKit

class DifficultyModel {
    
    var difficulties:[Difficulty] = []
    
    func loadDummyData() {
        let beginner = Difficulty(name: "Beginner", numberOfTiles: 81, numberOfMines: 10)
        let advanced = Difficulty(name: "Advanced", numberOfTiles: 16, numberOfMines: 40)
        
        difficulties.append(beginner)
        difficulties.append(advanced)
    }
    
    var elementCount: Int {
        return difficulties.count
    }
    
    func elementAtIndex(index: Int) -> (Difficulty) {
        guard index < elementCount else {
            fatalError("Invalid index: \(index). elementCount is \(elementCount).")
        }
        
        let dif = difficulties[index]
        return (dif)
    }
}