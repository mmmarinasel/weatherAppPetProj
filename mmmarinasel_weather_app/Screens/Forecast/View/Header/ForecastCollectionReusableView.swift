import UIKit

class ForecastCollectionReusableView: UICollectionReusableView {
    
    @IBOutlet weak var containerView: UIView!

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

    static let id = "forecastHeader"
    
    func setup(forecast: WeatherForecast?) {
        self.containerView.addSubview(self.cityLabel)
        self.cityLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        self.cityLabel.topAnchor.constraint(lessThanOrEqualTo: containerView.topAnchor,
                                            constant: 40).isActive = true
        self.cityLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: 20).isActive = true
        self.cityLabel.numberOfLines = 0
        self.containerView.backgroundColor = UIColor(named: "forecast_background")
        
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
        
        guard let forecast = forecast else { return }
        
        self.cityLabel.text = forecast.location.name
        let currentTemp = Int(forecast.current.temperature)
        self.currentTempLabel.text = "\(currentTemp)º"
        self.descriptionLabel.text = forecast.current.condition.text
        let todayForecast = forecast.forecast.forecastday[0].day
        let minTemp = Int(todayForecast.minTemp)
        let maxTemp = Int(todayForecast.maxTemp)
        self.tempsLabel.text = "H:\(maxTemp)º L: \(minTemp)º"
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
