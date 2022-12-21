import Foundation

class CitiesListViewModel {
    
    var cities: [String] = ["Warsaw", "Shah Alam", "Budapest", "Santa Cruz de la Sierra", "Porto Alegre", "Bremen", "Florence", "Buenos Aires", "Guayaquil", "Soledad"]
    
    var weatherForecast: Observable<WeatherForecast?> = Observable(nil)
    
    init() {
        ForecastService.getForecast(urlString: ForecastService.weatherForecastUrl) { [weak self] weatherData in
            let data: WeatherForecast = weatherData
            self?.weatherForecast.value = data
        }
    }
}
