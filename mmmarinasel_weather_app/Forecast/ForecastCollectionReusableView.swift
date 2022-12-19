import UIKit

class ForecastCollectionReusableView: UICollectionReusableView {
    private lazy var cityLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        guard let superview = superview else { return UILabel() }
        let constraints = [
            label.centerXAnchor.constraint(equalTo: superview.centerXAnchor),
            label.topAnchor.constraint(lessThanOrEqualTo: superview.topAnchor, constant: 20)
        ]
        label.font = UIFont.systemFont(ofSize: 34)
        label.textColor = .white
        return label
    }()
    
    func setLabels(text: String) {
        self.addSubview(cityLabel)
    }
}
