import Foundation

class ForecastViewModel: NSObject {
    var weatherForecast: Observable<WeatherForecast?> = Observable(nil)
    
    var reloadCollectionView: (() -> Void)?
    
    var hourlyCellViewModels = [HourlyCellViewModel]() {
        didSet {
            reloadCollectionView?()
        }
    }
    
    var weeklyCellViewModels = [WeeklyCellViewModel]() {
        didSet {
            reloadCollectionView?()
        }
    }
    
    override init() {
        super.init()
        ForecastService.getForecast(urlString: ForecastService.weatherForecastUrl) { [weak self] weatherData in
            let data: WeatherForecast = weatherData
            self?.weatherForecast.value = data
            self?.fetchHourlyData()
            self?.fetchWeeklyData()
        }
        
    }
    
    func getHourlyCellViewModel(at indexPath: IndexPath) -> HourlyCellViewModel? {
        guard !hourlyCellViewModels.isEmpty else { return nil }
        return self.hourlyCellViewModels[indexPath.row]
    }
    
    func getWeeklyCellViewModel(at indexPath: IndexPath) -> WeeklyCellViewModel? {
        guard !weeklyCellViewModels.isEmpty else { return nil }
        return self.weeklyCellViewModels[indexPath.row]
    }
    
    func fetchHourlyData() {
        var vms = [HourlyCellViewModel]()
        guard let forecast = self.weatherForecast.value else { return }
        guard let forecasts = forecast?.forecast.forecastday else { return }
        guard let forecastTime = forecast?.location.localtime else { return }
        var index = 0
        for item in forecasts[0].hourlyForecast {
            if convertDateFormat(item.time, dateFormat: "yyyyMMddHH") < convertDateFormat(forecastTime, dateFormat: "yyyyMMddHH") {
                continue
            }
            vms.append(createHourlyCellModel(forecast: item))
            index += 1
        }
        
        guard forecasts.count >= 2 else { return }
        guard index < 24 else { return }
        
        for item in forecasts[1].hourlyForecast {
            if index > 24 {
                break
            }
            vms.append(createHourlyCellModel(forecast: item))
        }
        self.hourlyCellViewModels = vms
    }
    
    func fetchWeeklyData() {
        var vms = [WeeklyCellViewModel]()
        guard let forecast = self.weatherForecast.value else { return }
        guard let forecasts = forecast?.forecast.forecastday else { return }
        guard forecasts.count >= 3 else { return }
        for idx in 0..<3 {
            vms.append(createWeeklyCellModel(forecast: forecasts[idx]))
        }
        for idx in 0..<3 {
            vms.append(createWeeklyCellModel(forecast: forecasts[idx]))
        }
//        for idx in 1..<3 {
//            vms.append(createWeeklyCellModel(forecast: forecasts[idx]))
//        }
        vms.append(createWeeklyCellModel(forecast: forecasts[1]))
        self.weeklyCellViewModels = vms
    }
    
    func createHourlyCellModel(forecast: HourlyForecast) -> HourlyCellViewModel {
        var currentTime = convertDateFormat(forecast.time,
                                            dateFormat: "HH a")
        let imageName = setImageName(condition: forecast.condition.text)
        let temperature = "\(Int(forecast.temperature))º"
        if getCurrentHours() == convertDateFormat(currentTime, dateFormat: "HH a") {
            currentTime = "Now"
        }
        return HourlyCellViewModel(currentTime: currentTime,
                                   imageName: imageName,
                                   temperature: temperature)
    }
    
    func createWeeklyCellModel(forecast: ForecastDay) -> WeeklyCellViewModel {
//        let day = convertDateFormat(forecast.date, dateFormat: "EEEE")
        let day = convertDateFormat(forecast.date, dateFormat: "yyyy-MM-dd", toDT: "EEEE")
        let imageName = setImageName(condition: forecast.day.condition.text)
        var chanceOfPrecipitation = ""
        if forecast.day.chanceOfRain > 0 {
            chanceOfPrecipitation = "\(forecast.day.chanceOfRain)%"
        } else if forecast.day.chacneOfSnow > 0 {
            chanceOfPrecipitation = "\(forecast.day.chacneOfSnow)%"
        } else {
            chanceOfPrecipitation = "no"
        }
        let maxTemp = "\(Int(forecast.day.maxTemp))"
        let minTemp = "\(Int(forecast.day.minTemp))"
        
        return WeeklyCellViewModel(day: day,
                                   imageString: imageName,
                                   chanceOfPrecipitation: chanceOfPrecipitation,
                                   maxTemp: maxTemp,
                                   minTemp: minTemp)
    }
    
    func convertDateFormat(_ str: String, dateFormat: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        let date = dateFormatter.date(from: str)
        dateFormatter.dateFormat = dateFormat
        guard let date = date else { return "" }
        return dateFormatter.string(from: date)
    }
    
    func convertDateFormat(_ str: String, dateFormat: String, toDT: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = dateFormat
        let date = dateFormatter.date(from: str)
        dateFormatter.dateFormat = toDT
        guard let date = date else { return "" }
        return dateFormatter.string(from: date)
    }
    
    func getCurrentHours() -> String {
        let date = Date.now
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH a"
        return dateFormatter.string(from: date)
    }
    
    func setImageName(condition: String) -> String {
        switch condition {
        case "Sunny":
            return "sunny"
        case "Rain", "Light freezing rain", "Patchy rain possible", "Heavy freezing drizzle", "Light drizzle", "Patchy light drizzle":
            return "rain"
        case "Snow":
            return "snow"
        case "Mist", "Fog":
            return "fog"
        case "Clear", "Cloudy":
            return "cloudy"
        case "Partly cloudy", "Overcast":
            return "overcast"
        case "Thunderstorm":
            return "thunderstorm"
        default:
            return "cloudy"
        }
    }
}
