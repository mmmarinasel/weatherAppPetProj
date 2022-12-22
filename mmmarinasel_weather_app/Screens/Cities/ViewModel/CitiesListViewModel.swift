import Foundation

class CitiesListViewModel: NSObject {
    
    private var urlString: String = "https://api.weatherapi.com/v1/current.json?key=ae5d9a6d0f044d30abb231756221712&q="
    private var cities: [String] = ["Warsaw", "Shah%20Alam", "Budapest", "Santa%20Cruz%20de%20la%20Sierra", "Porto%20Alegre", "Bremen", "Florence", "Buenos%20Aires", "Guayaquil", "Soledad"]
    
    var currentWeather: Observable<[CurrentWeather]> = Observable([])
    
    var reloadTableView: (() -> Void)?
    
    var citiesCellViewModels = [CityCellViewModel]() {
        didSet {
            reloadTableView?()
        }
    }
    
    override init() {
        super.init()
        var urls: [String] = []
        for city in cities {
            urls.append("\(self.urlString)\(city)")
        }
        for url in urls {
            ForecastService.getForecast(urlString: url) { [weak self] current in
                let data: CurrentWeather = current
                self?.currentWeather.value?.append(data)
                self?.fetchCitiesData()
                
            }
        }
    }
    
    func getCityCellViewModel(at indexPath: IndexPath) -> CityCellViewModel? {
        guard !citiesCellViewModels.isEmpty else { return nil }
        return self.citiesCellViewModels[indexPath.row]
    }
    
    func fetchCitiesData() {
        var vms = [CityCellViewModel]()
        guard let currentWeather = self.currentWeather.value else { return }
//        guard currentWeather.count >= 10 else { return }
        for weather in currentWeather {
            vms.append(createCityCellViewModel(data: weather))
        }
        self.citiesCellViewModels = vms
    }
    
    func createCityCellViewModel(data: CurrentWeather) -> CityCellViewModel {
        let time = getCurrentTime(data.location.localtime)
        let city = data.location.name
        let currentTemp = "\(Int(data.current.temp))º"
        let imageName = setImageName(condition: data.current.description.text)
        return CityCellViewModel(currentTemperature: currentTemp,
                                 city: city,
                                 time: time,
                                 imageName: imageName)
        
    }
    
    func getCurrentTime(_ str: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        let date = dateFormatter.date(from: str)
        dateFormatter.dateFormat = "HH:mm"
        guard let date = date else { return "" }
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
