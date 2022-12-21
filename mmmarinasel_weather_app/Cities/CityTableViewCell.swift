import UIKit

class CityTableViewCell: UITableViewCell {
    
    @IBOutlet weak var currentTempLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    static let id: String = "cityCell"

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setTimeLabel(date: String) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        let date = dateFormatter.date(from: date) ?? Date.now
        dateFormatter.dateFormat = "HH:mm"
        let dateStr = dateFormatter.string(from: date)
        self.timeLabel.text = dateStr
    }
    
    func setTempLabel(tempFloat: Float?) {
        guard let tempFloat = tempFloat else { return }
        let temp = Int(tempFloat)
        self.currentTempLabel.text = "\(temp)º"
    }
}
