import Foundation

class Scoreboard {
    var scores:[(String, Int, Int)] = []
    
    func addScore(name name: String, seconds: Int, moves: Int){
        scores.append((name, seconds, moves))
        /*scores.sortInPlace { (<#Self.Generator.Element#>, <#Self.Generator.Element#>) -> Bool in
            <#code#>
        }*/
    }
}