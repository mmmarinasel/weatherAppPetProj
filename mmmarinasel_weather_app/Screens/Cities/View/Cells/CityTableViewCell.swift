import UIKit

class CityTableViewCell: UITableViewCell {
    
    @IBOutlet weak var currentTempLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var weatherImageView: UIImageView!
    static let id: String = "cityCell"
    
    var cellViewModel: CityCellViewModel? {
        didSet {
            currentTempLabel.text = cellViewModel?.currentTemperature
            cityLabel.text = cellViewModel?.city
            timeLabel.text = cellViewModel?.time
            weatherImageView.image = UIImage(named: cellViewModel?.imageName ?? "sunny")
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
