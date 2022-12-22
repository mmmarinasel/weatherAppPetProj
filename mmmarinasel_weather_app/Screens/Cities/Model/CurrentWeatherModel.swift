import Foundation

struct CurrentWeather: Codable {
    var location: CurrentLocation
    var current: Current
}

struct CurrentLocation: Codable {
    var name: String
    var localtime: String
}

struct Current: Codable {
    var temp: Float
    var description: Description
    enum CodingKeys: String, CodingKey {
        case temp = "temp_c"
        case description = "condition"
    }
}

struct Description: Codable {
    var text: String
}
