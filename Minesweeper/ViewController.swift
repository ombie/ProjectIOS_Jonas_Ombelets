import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var boardView: UIView!
    @IBOutlet weak var movesLabel: UILabel!
    @IBOutlet weak var mineLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var flagSwitch: UISwitch!
    
    var scoreboard:Scoreboard
    
    var difficulty:Difficulty!
    
    let BOARD_SIZE:Int = 9
    var board:Gameboard
    var squareButtons:[[SquareButton]] = []
    
    var moves:Int = 0 {
        didSet {
            self.movesLabel.text = "Moves: \(moves)"
            //self.movesLabel.sizeToFit()
        }
    }
    
    var minesLeft:Int = 10 {
        didSet{
            self.mineLabel.text = "Mines left: \(minesLeft)"
            //self.mineLabel.sizeToFit()
        }
    }
    var minesLeftCorrectly: Int = 10
    
    var timeTaken:Int = 0  {
        didSet {
            self.timeLabel.text = "Time: \(timeTaken)"
            //self.timeLabel.sizeToFit()
        }
    }
    
    var flagedCorrectly = true;
    var numberOfNormalSquares:Int = -1
    var numberOfRevealedNormalSquares:Int = 0
    
    // optional => give nil value tot timer between an ended game and a new game
    var oneSecondTimer:NSTimer?
    
    // custom init method
    required init(coder aDecoder: NSCoder)
    {
        self.board = Gameboard(size: BOARD_SIZE)
        self.scoreboard = Scoreboard()
        //self.difficulty =
        super.init(coder: aDecoder)!
    }
    
    // initializing the board
    func initializeBoard() {
        let squareSize:CGFloat = self.boardView.frame.width / (CGFloat(BOARD_SIZE)*2)
        for col in 0 ..< board.size {
            var squareBtnCol: [SquareButton] = []
            for row in 0 ..< board.size {
                let square = board.squares[col][row]
                let squareButton = SquareButton(squareModel: square, squareSize: squareSize)
                
                squareButton.setTitleColor(UIColor.darkGrayColor(), forState: .Normal)
                squareButton.addTarget(self, action: "squareButtonPressed:", forControlEvents: .TouchUpInside)
                
                squareBtnCol.append(squareButton)
                self.boardView.addSubview(squareButton)
            }
            self.squareButtons.append(squareBtnCol)
        }
    }
    
    func squareButtonPressed(sender: SquareButton) {
        if(!sender.square.isRevealed) {
            self.moves++
            sender.square.isRevealed = true
            
            // flag a mine
            if(flagSwitch.on) {
                sender.setTitle("F", forState: .Normal)
                self.minesLeft--
                if(sender.square.isMineLocation) {
                    self.minesLeftCorrectly--
                    self.flagedCorrectly =  self.flagedCorrectly && sender.square.isMineLocation
                    if(minesLeft == 0 && flagedCorrectly) {
                        self.finishedGame()
                    }
                } else {
                    self.flagedCorrectly = false
                }
            } else {
                sender.setTitle("\(sender.getLabelText())", forState: .Normal)
                if(sender.square.isMineLocation) {
                    sender.setTitleColor(UIColor.redColor(), forState: .Normal)
                    self.minePressed()
                } else if(sender.square.hasNoNeighborMines) {
                    self.numberOfRevealedNormalSquares++
                    //print("Pressed col:\(sender.square.xCo), row:\(sender.square.yCo), :\(sender.getLabelText())")
                    // show text for each neighbor
                    for neighborSquare in sender.square.neighbors {
                        if(!neighborSquare.isRevealed && !neighborSquare.isMineLocation) {
                            neighborSquareButtonReveal(neighborSquare.xCo, y: neighborSquare.yCo)
                        }
                    }
                } else {
                    self.numberOfRevealedNormalSquares++
                }
            }
            
            print(numberOfRevealedNormalSquares)
            print(flagedCorrectly)
            
            if(numberOfRevealedNormalSquares == numberOfNormalSquares){
                print("we did it \(self.numberOfRevealedNormalSquares)")
                print(numberOfNormalSquares)
                self.finishedGame()
            } else if(flagedCorrectly && numberOfRevealedNormalSquares == (self.BOARD_SIZE*self.BOARD_SIZE - (self.board.numberOfMines - self.minesLeft))){ // numberOfRevealedNormalSquares == numberOfNormalSquares - (self.board.numberOfMines - self.minesLeft)
                self.finishedGame()
                print(self.numberOfRevealedNormalSquares)
            }
        }
    }
    
    func neighborSquareButtonReveal(x: Int, y: Int) {
        let neighborWithoutMine = squareButtons[x][y]
        neighborWithoutMine.square.isRevealed = true
        numberOfRevealedNormalSquares++
        neighborWithoutMine.setTitle("\(neighborWithoutMine.getLabelText())", forState: .Normal)
        //print("Neighbor Pressed col:\(neighborWithoutMine.square.xCo), row:\(neighborWithoutMine.square.yCo), :\(neighborWithoutMine.getLabelText())")
        if(neighborWithoutMine.square.hasNoNeighborMines) {
            // show text for each neighbor
            for neighborSquare in neighborWithoutMine.square.neighbors {
                if(!neighborSquare.isRevealed && !neighborSquare.isMineLocation) {
                    neighborSquareButtonReveal(neighborSquare.xCo, y: neighborSquare.yCo)
                }
            }
        }
    }
    
    // showing an alert when a mine is pressed
    func  minePressed() {
        self.endCurrentGame()
        self.minesLeft--
        
        // showing all mines
        for mine in self.board.minesArray {
            if(!mine.isRevealed) {
                squareButtons[mine.xCo][mine.yCo].setTitle("\(squareButtons[mine.xCo][mine.yCo].getLabelText())", forState: .Normal)
                print("(\(mine.xCo) ,\(mine.yCo))")
            }
        }
        
        /*let alertView = UIAlertView()
        alertView.addButtonWithTitle("New Game")
        alertView.addButtonWithTitle("Close")
        alertView.title = "BOOM!"
        alertView.message = "You tapped a mine 😒"
        alertView.show()
        
        alertView.delegate = self*/
        
        makeLosingAlertController()
    }
    
    func finishedGame(){
        self.endCurrentGame()
        /*let alertView = UIAlertView()
        alertView.addButtonWithTitle("New Game")
        alertView.addButtonWithTitle("Add highscore")
        alertView.title = "CONGRATULATIONS!"
        alertView.message = "You finished the game in: \(self.timeTaken) seconds"
        alertView.show()
        alertView.delegate = self*/
        
        self.scoreboard.addScore(name: "", seconds: self.timeTaken, moves: self.moves)
        print(self.scoreboard.scores)
        
        var winningAlertController = UIAlertController(title: "CONGRATULATIONS!", message: "You finished the game in: \(self.timeTaken) seconds", preferredStyle: .Alert)
        
        let addHighscoreAction = UIAlertAction(title: "Add Highscore", style: .Default) {
            (alert: UIAlertAction) -> Void in print(self.scoreboard.scores)
        }
        
        winningAlertController = addNewGameActionToAlertController(winningAlertController)
        winningAlertController.addAction(addHighscoreAction)
        
        self.presentViewController(winningAlertController, animated: true, completion: nil)
    }
    
    func makeLosingAlertController() {
        var losingAlertController = UIAlertController(title: "BOOM!", message: "You tapped a mine 😒", preferredStyle: .Alert)
        
        let closeAction = UIAlertAction(title: "Close", style: .Default) {
            (alert: UIAlertAction) -> Void in self.dismissViewControllerAnimated(true, completion: nil)
            // disable possible click on square
            for squareBtnArray in self.squareButtons {
                for squareBtn in squareBtnArray {
                    squareBtn.removeTarget(self, action: "squareButtonPressed:", forControlEvents: .TouchUpInside)
                }
            }
        }
        
        losingAlertController = addNewGameActionToAlertController(losingAlertController)
        losingAlertController.addAction(closeAction)
        
        self.presentViewController(losingAlertController, animated: true, completion: nil)
    }
    
    func addNewGameActionToAlertController(alertController: UIAlertController) -> UIAlertController {
        let newGameAction = UIAlertAction(title: "New Game", style: .Default) {
            (alert: UIAlertAction!) -> Void in self.startNewGame()
        }
        
        alertController.addAction(newGameAction)
        return alertController
    }
    
    // when the first button on the alertView is clicked => startNewGame()
    /*func alertView(View: UIAlertView!, clickedButtonAtIndex buttonIndex: Int) {
        switch(buttonIndex){
        case 0:
            self.startNewGame()
            break
        case 1:
            View.dismissWithClickedButtonIndex(1, animated: true)
            for squareBtnArray in squareButtons {
                for squareBtn in squareBtnArray {
                    squareBtn.removeTarget(self, action: "squareButtonPressed:", forControlEvents: .TouchUpInside)
                }
            }
            break
        default:
            break
        }
    }*/
    
    func oneSecond() {
        self.timeTaken++
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.initializeBoard()
        self.startNewGame()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func newGamePressed() {
        self.endCurrentGame()
        print("new game")
        self.startNewGame()
    }
    
    func startNewGame() {
        //start new game
        self.resetBoard()
        self.timeTaken = 0
        self.moves = 0
        self.minesLeft = self.board.numberOfMines
        self.minesLeftCorrectly = self.board.numberOfMines
        self.flagSwitch.setOn(false, animated: true)
        self.flagedCorrectly = true
        self.numberOfNormalSquares = self.BOARD_SIZE * self.BOARD_SIZE - self.board.numberOfMines
        self.numberOfRevealedNormalSquares = 0
        
        
        // create new timer
        self.oneSecondTimer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: Selector("oneSecond"), userInfo: nil, repeats: true)
    }
    
    func endCurrentGame() {
        self.oneSecondTimer?.invalidate()
        self.oneSecondTimer = nil
    }
    
    // called when view is loaded and when newGamePressed
    func resetBoard() {
        // resets the board with new mine locations & sets isRevealed to false for each square
        self.board.resetGameboard()
        // iterates through each button and resets the text to the default value
        
        for col in 0 ..< BOARD_SIZE {
            for row in 0 ..< BOARD_SIZE {
                squareButtons[col][row].setTitle("[x]", forState: .Normal)
                squareButtons[col][row].setTitleColor(UIColor.blackColor(), forState: .Normal)
                squareButtons[col][row].addTarget(self, action: "squareButtonPressed:", forControlEvents: .TouchUpInside)
            }
        }
    }
}

