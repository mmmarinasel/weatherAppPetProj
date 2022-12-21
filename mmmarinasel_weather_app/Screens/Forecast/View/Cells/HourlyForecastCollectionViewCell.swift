import UIKit

class HourlyForecastCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var timeLabel: UILabel!    
    @IBOutlet weak var weatherImageView: UIImageView!
    @IBOutlet weak var tempLabel: UILabel!
//    static let id = "hourlyForecastCell"
    class var id: String { return String(describing: self) }
    
    func setup(forecast: WeatherForecast?, idx: Int) {
        guard let forecast = forecast else { return }
        if convertDateFormat(forecast.location.localtime, dateFormat: "HH:mm a") == getCurrentHours() {
            self.timeLabel.text = "Now"
        } else {
            self.timeLabel.text = convertDateFormat(forecast.location.localtime, dateFormat: "HH a")
        }
        self.weatherImageView.image = setImage(condition: forecast.forecastday?[0].hourlyForecast[idx].condition.text ?? "sunny")
        self.tempLabel.text = "\(Int(forecast.forecastday?[0].hourlyForecast[idx].temperature ?? 0))"
    }
    
    func getCurrentHours() -> String {
        let date = Date.now
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm a"
//        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
        return dateFormatter.string(from: date)
    }
    
    func convertDateFormat(_ str: String, dateFormat: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        let date = dateFormatter.date(from: str)
        dateFormatter.dateFormat = dateFormat
        guard let date = date else { return "" }
        return dateFormatter.string(from: date)
    }
    
    func setImage(condition: String) -> UIImage {
        var descr: String = ""
        switch condition {
        case "Sunny":
            descr = "sunny"
        case "Rain", "Light freezing rain", "Patchy rain possible", "Heavy freezing drizzle", "Light drizzle", "Patchy light drizzle":
            descr = "rain"
        case "Snow":
            descr = "snow"
        case "Mist", "Fog":
            descr = "fog"
        case "Clear", "Cloudy":
            descr = "cloudy"
        case "Partly cloudy", "Overcast":
            descr = "overcast"
        case "Thunderstorm":
            descr = "thunderstorm"
        default:
            descr = "cloudy"
        }
    
        return UIImage(named: descr) ?? UIImage()
    }
    
}
