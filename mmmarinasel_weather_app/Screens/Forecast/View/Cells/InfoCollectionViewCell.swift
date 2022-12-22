import UIKit

class InfoCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    
    static let id: String = "infoCell"
    
    var cellViewModel: InfoCellViewModel? {
        didSet {
            nameLabel.text = cellViewModel?.name
            infoLabel.text = cellViewModel?.info
        }
    }
}
