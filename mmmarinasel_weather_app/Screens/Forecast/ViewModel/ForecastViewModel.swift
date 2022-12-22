import Foundation

class ForecastViewModel: NSObject {
    
    let weatherForecastUrl = "https://api.weatherapi.com/v1/forecast.json?key=ae5d9a6d0f044d30abb231756221712&q="
    
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
    
    var infoCellViewModels = [InfoCellViewModel]() {
        didSet {
            reloadCollectionView?()
        }
    }

    var city: String? {
        didSet {
            self.getDataForCity()
        }
    }
    
    override init() {
        super.init()
    }
    
    func getDataForCity() {
        let replaced = self.city?.replacingOccurrences(of: " ", with: "%20")
        
        let url: String = "\(self.weatherForecastUrl)\(replaced ?? "")&days=8"
        ForecastService.getForecast(urlString: url) { [weak self] weatherData in
            let data: WeatherForecast = weatherData
            self?.weatherForecast.value = data
            self?.fetchHourlyData()
            self?.fetchWeeklyData()
            self?.fetchInfoData()
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
    
    func getInfoCellViewModel(at indexPath: IndexPath) -> InfoCellViewModel? {
        guard !infoCellViewModels.isEmpty else { return nil }
        return self.infoCellViewModels[indexPath.row]
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
    
    func fetchInfoData() {
        var vms = [InfoCellViewModel]()
        guard let forecast = self.weatherForecast.value else { return }
        guard let forecasts = forecast?.forecast.forecastday else { return }
        guard let forecastTime = forecast?.location.localtime else { return }
        vms.append(InfoCellViewModel(name: "SUNRISE", info: forecasts[0].astro.sunrise))
        vms.append(InfoCellViewModel(name: "SUNSET", info: forecasts[0].astro.sunset))
        for item in forecasts[0].hourlyForecast {
            if convertDateFormat(item.time, dateFormat: "yyyy-MM-dd HH") == convertDateFormat(forecastTime, dateFormat: "yyyy-MM-dd HH") {
                vms.append(InfoCellViewModel(name: "CHANCE OF RAIN", info: "\(item.chanceOfRain)%"))
                vms.append(InfoCellViewModel(name: "HUMIDITY", info: "\(item.humidity)%"))
                vms.append(InfoCellViewModel(name: "WIND", info: "\(item.windDirectory) \(Int(item.windSpeed)) km/hr"))
                vms.append(InfoCellViewModel(name: "FEELS LIKE", info: "\(Int(item.feelsLike))º"))
                vms.append(InfoCellViewModel(name: "PRECIPITATION", info: "\(Int(item.precipitation)) cm"))
                vms.append(InfoCellViewModel(name: "PRESSURE", info: "\(Int(item.pressure)) hPa"))
                vms.append(InfoCellViewModel(name: "VISIBILITY", info: "\(item.visibility) km"))
                vms.append(InfoCellViewModel(name: "UV INDEX", info: "\(Int(item.uv))"))
            }
        }
        self.infoCellViewModels = vms
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
        case "Thunderstorm", "Thunder", "Moderate or heavy rain with thunder":
            return "thunderstorm"
        default:
            return "cloudy"
        }
    }
}
