import UIKit

class CityTableViewCell: UITableViewCell {
    
//    private lazy var timeLabel: UILabel = {
//        var label = UILabel()
//        label.translatesAutoresizingMaskIntoConstraints = false
//        let constraints = [
////            label.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor,
////                                           constant: 20),
//            label.leadingAnchor.constraint(equalTo: self.contentView.layoutMarginsGuide.leadingAnchor,
//                                           constant: 20)
//        ]
//        NSLayoutConstraint.activate(constraints)
//        label.font = UIFont.systemFont(ofSize: 15)
//        label.textColor = .white
//        return label
//    }()
    
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
//        self.contentView.addSubview(self.timeLabel)
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
