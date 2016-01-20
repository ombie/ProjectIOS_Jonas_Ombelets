import UIKit

class HomeController: UIViewController {
    
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var highscoreButton: UIButton!
    @IBOutlet weak var infoButton: UIButton!
    @IBOutlet weak var infoView: UITextView!

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        switch segue.identifier! {
        case "play":
            let difficultyController = (segue.destinationViewController as! UINavigationController).topViewController as! DifficultyController
            let model = DifficultyModel()
            difficultyController.model = model
            model.loadDummyData()
        default:
            fatalError("Unknown segue in \(self.dynamicType).")
        }
    }
    
    @IBAction func unwindFromDif(segue: UIStoryboardSegue) {
        let difficultyController = segue.sourceViewController as! DifficultyController
    }
    
    @IBAction func showInfo() {
        if (self.infoView.hidden) {
            self.infoView.hidden = false
        } else {
            self.infoView.hidden = true
        }
    }
    
}
