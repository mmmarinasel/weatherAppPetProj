import Foundation

class ForecastViewModel {
    var weatherForecast: Observable<WeatherForecast?> = Observable(nil)
    
    init() {
        ForecastService.getForecast(urlString: ForecastService.weatherForecastUrl) { [weak self] weatherData in
            let data: WeatherForecast = weatherData
            self?.weatherForecast.value = data
        }
    }
}
