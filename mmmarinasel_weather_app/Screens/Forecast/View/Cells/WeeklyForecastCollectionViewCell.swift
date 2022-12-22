import UIKit

class WeeklyForecastCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var weatherImageView: UIImageView!
    @IBOutlet weak var chanceOfPrecipitationLabel: UILabel!
    @IBOutlet weak var maxTempLabel: UILabel!
    @IBOutlet weak var minTempLabel: UILabel!
    
    static let id: String = "weeklyForecastCell"
    
    var cellViewModel: WeeklyCellViewModel? {
        didSet {
            dayLabel.text = cellViewModel?.day
            weatherImageView.image = UIImage(named: cellViewModel?.imageString ?? "sunny")
            if cellViewModel?.chanceOfPrecipitation == "no" {
                chanceOfPrecipitationLabel.isHidden = true
            } else {
                chanceOfPrecipitationLabel.text = cellViewModel?.chanceOfPrecipitation
            }
            maxTempLabel.text = cellViewModel?.maxTemp
            minTempLabel.text = cellViewModel?.minTemp
        }
    }
}
