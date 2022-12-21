import UIKit

class HourlyForecastCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var timeLabel: UILabel!    
    @IBOutlet weak var weatherImageView: UIImageView!
    @IBOutlet weak var tempLabel: UILabel!
    static let id = "hourlyForecastCell"
    
//    private lazy var timeLabel: UILabel = {
//        var label = UILabel()
//
//        label.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
//        label.textColor = .white
//        label.backgroundColor = .systemPink
//        label.text = "LOL"
//        label.textAlignment = .center
//        return label
//    }()
//
//    private lazy var weatherImageView: UIImageView = {
//        var image = UIImageView()
//        image.translatesAutoresizingMaskIntoConstraints = false
//        image.image = UIImage(named: "sunny")
//        return image
//    }()
    
//    func setup() {
//        self.contentView.addSubview(self.weatherImageView)
//        self.weatherImageView.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor).isActive = true
//        self.weatherImageView.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor).isActive = true
//        self.weatherImageView.heightAnchor.constraint(equalToConstant: 30).isActive = true
//        self.weatherImageView.widthAnchor.constraint(equalToConstant: 30).isActive = true
//
//        self.contentView.addSubview(self.timeLabel)
//        self.timeLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor).isActive = true
//        self.timeLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 12).isActive = true
//        self.timeLabel.widthAnchor.constraint(equalTo: self.contentView.widthAnchor).isActive = true
//    }
}
