import UIKit

class WeeklyForecastCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var weatherImageView: UIImageView!
    @IBOutlet weak var chanceOfPrecipitationLabel: UILabel!
    @IBOutlet weak var maxTempLabel: UILabel!
    @IBOutlet weak var minTempLabel: UILabel!
    
    static let id: String = "weeklyForecastCell"
    
    func setup(forecast: WeatherForecast?, idx: Int) {
        guard let forecast = forecast else { return }
        let index = idx + 1
        self.dayLabel.text = convertToWeekday(str: forecast.forecastday?[index].date ?? "")
        if forecast.forecastday?[index].day.chacneOfSnow ?? 0 > 0 {
            self.chanceOfPrecipitationLabel.text = "\(forecast.forecastday?[index].day.chacneOfSnow ?? 0)%"
        } else if forecast.forecastday?[index].day.chanceOfRain ?? 0 > 0 {
            self.chanceOfPrecipitationLabel.text = "\(forecast.forecastday?[index].day.chanceOfRain ?? 0)%"
        } else {
            self.chanceOfPrecipitationLabel.isHidden = true
        }
        self.weatherImageView.image = setImage(condition: forecast.forecastday?[index].day.condition.text ?? "sunny")
        self.maxTempLabel.text = "\(Int(forecast.forecastday?[index].day.maxTemp ?? 0))"
        self.minTempLabel.text = "\(Int(forecast.forecastday?[index].day.minTemp ?? 0))"
    }
    
    func convertToWeekday(str: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        let date = dateFormatter.date(from: str)
        dateFormatter.dateFormat = "EEEE"
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
