import UIKit

class SearchTableViewCell: UITableViewCell {

    @IBOutlet weak var searchTextField: SearchTextField!
    
    static let id: String = "searchCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
