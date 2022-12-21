import UIKit

class ForecastCollectionReusableView: UICollectionReusableView {
    
    static let id = "forecastHeader"
    
    @IBOutlet weak var containerView: UIView!
    //    lazy var containerView: UIView = {
//        var view = UIView()
//        view.translatesAutoresizingMaskIntoConstraints = false
//        view.backgroundColor = UIColor(named: "forecast_background")
//        return view
//    }()
    
    lazy var cityLabel: UILabel = {
        let font = UIFont.systemFont(ofSize: 34)
        return self.buildLabel(font: font)
    }()
    
    lazy var currentTempLabel: UILabel = {
        let font = UIFont.systemFont(ofSize: 96, weight: .thin)
        return self.buildLabel(font: font)
    }()
    
    lazy var descriptionLabel: UILabel = {
        let font = UIFont.systemFont(ofSize: 20, weight: .medium)
        return self.buildLabel(font: font)
    }()
    
    lazy var tempsLabel: UILabel = {
        let font = UIFont.systemFont(ofSize: 20)
        return self.buildLabel(font: font)
    }()
    
    func setLabels(text: String) {
//        self.addSubview(self.containerView)
//        guard let superview = superview else { return }
//        self.containerView.leadingAnchor.constraint(equalTo: superview.leadingAnchor).isActive = true
//        self.containerView.trailingAnchor.constraint(equalTo: superview.trailingAnchor).isActive = true
//        self.containerView.topAnchor.constraint(equalTo: superview.topAnchor).isActive = true
//        self.containerView.bottomAnchor.constraint(equalTo: superview.bottomAnchor).isActive = true
        
        self.containerView.addSubview(self.cityLabel)
        self.cityLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        self.cityLabel.topAnchor.constraint(lessThanOrEqualTo: containerView.topAnchor,
                                            constant: 40).isActive = true
        
        self.containerView.addSubview(currentTempLabel)
        self.currentTempLabel.topAnchor.constraint(equalTo: self.cityLabel.bottomAnchor,
                                                   constant: 13).isActive = true
        self.currentTempLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        
        self.containerView.addSubview(self.descriptionLabel)
        self.descriptionLabel.topAnchor.constraint(equalTo: self.currentTempLabel.bottomAnchor,
                                                   constant: 13).isActive = true
        self.descriptionLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        
        self.containerView.addSubview(self.tempsLabel)
        self.tempsLabel.topAnchor.constraint(equalTo: self.descriptionLabel.bottomAnchor,
                                             constant: 1).isActive = true
        self.tempsLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        
        self.cityLabel.text = text
        self.currentTempLabel.text = "7º"
        self.descriptionLabel.text = "Mostly cloudy"
        self.tempsLabel.text = "H:8º L: 0º"
        self.containerView.backgroundColor = UIColor(named: "forecast_background")
    }
    
    func buildLabel(font: UIFont) -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = font
        label.textColor = .white
        label.textAlignment = .center
        return label
    }
}
