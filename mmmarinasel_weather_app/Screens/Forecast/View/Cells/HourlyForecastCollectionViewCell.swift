import UIKit

class HourlyForecastCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var timeLabel: UILabel!    
    @IBOutlet weak var weatherImageView: UIImageView!
    @IBOutlet weak var tempLabel: UILabel!
    static let id = "hourlyForecastCell"
    
    var cellViewModel: HourlyCellViewModel? {
        didSet {
            timeLabel.text = cellViewModel?.currentTime
            weatherImageView.image = UIImage(named: cellViewModel?.imageName ?? "sunny")
            tempLabel.text = cellViewModel?.temperature
        }
    }
}
