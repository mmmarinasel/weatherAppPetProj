import Foundation

class CitiesListViewModel: NSObject {
    
    private var urlString: String = "https://api.weatherapi.com/v1/current.json?key=ae5d9a6d0f044d30abb231756221712&q="
    private var cities: [String] = ["Warsaw", "Shah%20Alam", "Budapest", "Santa%20Cruz%20de%20la%20Sierra", "Porto%20Alegre", "Bremen", "Florence", "Buenos%20Aires", "Guayaquil", "Soledad"]
    
    var currentWeather: Observable<[CurrentWeather]> = Observable([])
    
    var citiesCellViewModels: Observable<[CityCellViewModel]> = Observable([])
    var citiesCellViewModelsFiltered: Observable<[CityCellViewModel]> = Observable([])

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
        guard !(citiesCellViewModels.value?.isEmpty ?? true) else { return nil }
        return self.citiesCellViewModelsFiltered.value?[indexPath.row]
    }
    
    func filter(_ query: String?) {
        if (query == nil || query == "") {
            self.citiesCellViewModelsFiltered.value = self.citiesCellViewModels.value
            return
        }
        guard let query = query else { return }
        self.citiesCellViewModelsFiltered.value = self.citiesCellViewModels.value?.filter{ $0.city.range(of: query, options: [.caseInsensitive, .anchored]) != nil }
    }
    
    private func fetchCitiesData() {
        var vms = [CityCellViewModel]()
        guard let currentWeather = self.currentWeather.value else { return }
        for weather in currentWeather {
            vms.append(createCityCellViewModel(data: weather))
        }
        self.citiesCellViewModels.value = vms
        self.citiesCellViewModelsFiltered.value = self.citiesCellViewModels.value
    }
    
    private func createCityCellViewModel(data: CurrentWeather) -> CityCellViewModel {
        let time = getCurrentTime(data.location.localtime)
        let city = data.location.name
        let currentTemp = "\(Int(data.current.temp))º"
        let imageName = setImageName(condition: data.current.description.text)
        return CityCellViewModel(currentTemperature: currentTemp,
                                 city: city,
                                 time: time,
                                 imageName: imageName)
        
    }
    
    private func getCurrentTime(_ str: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        let date = dateFormatter.date(from: str)
        dateFormatter.dateFormat = "HH:mm"
        guard let date = date else { return "" }
        return dateFormatter.string(from: date)
    }
    
    private func setImageName(condition: String) -> String {
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
