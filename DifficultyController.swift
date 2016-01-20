import UIKit

class DifficultyController: UICollectionViewController, UIPopoverPresentationControllerDelegate {
    var model: DifficultyModel!
    
    override func viewDidLoad() {
        collectionView!.allowsMultipleSelection = true
    }
    
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return model.elementCount
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let element = model.elementAtIndex(indexPath.item)
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("playDifficultyCell", forIndexPath: indexPath) as! PlayDifficultyCell
        cell.backgroundColor = UIColor.whiteColor()
        cell.layer.borderWidth = 1.0
        cell.layer.borderColor = (UIColor.blackColor()).CGColor
        cell.nameLabel.text = element.name
        cell.tileLabel.text = "\(element.numberOfTiles) tiles"
        cell.mineLabel.text = "\(element.numberOfMines) mines"
        
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionHeader, withReuseIdentifier: "headerCell", forIndexPath: indexPath) as! HeaderCell
        header.titleLabel.text = "Tap to choose the difficulty level to play"
        return header
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier("play", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        switch segue.identifier! {
        case "play":
            let selectedIndexPath = collectionView!.indexPathsForSelectedItems()!.first!//.first!
            let selectedCell = collectionView!.cellForItemAtIndexPath(selectedIndexPath)!
            let popover = segue.destinationViewController.popoverPresentationController!
            popover.sourceView = selectedCell
            popover.sourceRect = selectedCell.bounds
            popover.backgroundColor = UIColor.whiteColor()
            popover.delegate = self
            let viewController = (segue.destinationViewController as! UINavigationController).topViewController as! ViewController
            viewController.difficulty = model.elementAtIndex(selectedIndexPath.item)
            print(selectedIndexPath, model.difficulties)
            print(viewController.difficulty.name)
            collectionView?.deselectItemAtIndexPath(selectedIndexPath, animated: false)
        case "didChooseDif":
            break
        default:
            fatalError("Unknown segue in \(self.dynamicType). \(segue.identifier)")
        }
    }
    
    /*
    We override the following method to deselect the selected item when the popover is dismissed.
    The collection view allows multiple selection, but this should not happen outside of edit mode.
    */
    func popoverPresentationControllerDidDismissPopover(popoverPresentationController: UIPopoverPresentationController) {
        let selectedIndexPath = collectionView!.indexPathsForSelectedItems()!.first!
        collectionView!.deselectItemAtIndexPath(selectedIndexPath, animated: false)
    }
    
    @IBAction func unwindFromPlay(segue: UIStoryboardSegue) {
        let playController = segue.sourceViewController as! ViewController
    }
}