import UIKit

class SearchTableViewCell: UITableViewCell {

    @IBOutlet weak var searchTextField: SearchTextField!
    
    @IBAction func handleSearchTextField(_ sender: Any) {
        guard let vm = self.viewModel else { return }
        vm.filter(searchTextField.text)
    }
    static let id: String = "searchCell"
    var viewModel: CitiesListViewModel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
