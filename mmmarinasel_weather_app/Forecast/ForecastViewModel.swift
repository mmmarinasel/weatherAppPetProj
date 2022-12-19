import Foundation

class ForecastViewModel {
    var weatherForecast: Observable<WeatherForecast?> = Observable(nil)
    
    init() {
        Loader.getJson(urlString: Loader.weatherForecastUrl) { [weak self] weatherData in
            let data: WeatherForecast = weatherData
            self?.weatherForecast.value = data
        }
    }
}
