import Foundation

struct WeatherForecast: Codable {
    var location: Location
    var current: CurrentData
    var forecast: Forecast
}

struct Forecast: Codable {
    var forecastday: [ForecastDay]
}

struct Location: Codable {
    var name: String
    var localtime: String
}

struct CurrentData: Codable {
    var lastUpdated: String
    var temperature: Float
    var condition: Condition
    var windSpeed: Float
    var windDirectory: String
    var pressure: Float
    var precipitation: Float
    var humidity: Int
    var feelsLike: Float
    var visibility: Float
    var uv: Float
    
    enum CodingKeys: String, CodingKey {
        case lastUpdated = "last_updated"
        case temperature = "temp_c"
        case condition, humidity, uv
        case windSpeed = "wind_kph"
        case windDirectory = "wind_dir"
        case pressure = "pressure_mb"
        case precipitation = "precip_mm"
        case feelsLike = "feelslike_c"
        case visibility = "vis_km"
        
    }
}

struct Condition: Codable {
    var text: String
}

struct ForecastDay: Codable {
    var date: String
    var day: Day
    var astro: Astro
    var hourlyForecast: [HourlyForecast]
    
    enum CodingKeys: String, CodingKey {
        case date, day, astro
        case hourlyForecast = "hour"
    }
}

struct Day: Codable {
    var maxTemp: Float
    var minTemp: Float
    var chanceOfRain: Int
    var chacneOfSnow: Int
    var condition: Condition
    
    enum CodingKeys: String, CodingKey {
        case maxTemp = "maxtemp_c"
        case minTemp = "mintemp_c"
        case chanceOfRain = "daily_chance_of_rain"
        case chacneOfSnow = "daily_chance_of_snow"
        case condition
    }
}

struct Astro: Codable {
    var sunrise: String
    var sunset: String
}

struct HourlyForecast: Codable {
    var time: String
    var temperature: Float
    var condition: Condition
    var windSpeed: Float
    var windDirectory: String
    var pressure: Float
    var precipitation: Float
    var humidity: Int
    var feelsLike: Float
    var chanceOfRain: Int
    var chanceOfSnow: Int
    var visibility: Float
    var uv: Float
    
    enum CodingKeys: String, CodingKey {
        case time, condition, humidity, uv
        case temperature = "temp_c"
        case windSpeed = "wind_kph"
        case windDirectory = "wind_dir"
        case pressure = "pressure_mb"
        case precipitation = "precip_mm"
        case feelsLike = "feelslike_c"
        case chanceOfRain = "chance_of_rain"
        case chanceOfSnow = "chance_of_snow"
        case visibility = "vis_km"
    }
}
