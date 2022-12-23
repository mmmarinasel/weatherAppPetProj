import Foundation

protocol ForecastServiceProtocol {
    static func getForecast<T: Codable>(urlString: String, completion: @escaping (T) -> Void)
}

class ForecastService: ForecastServiceProtocol {
    
    private static func getData(urlString: String, completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
        guard let url = URL(string: urlString) else { return }
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    static func getForecast<T: Codable>(urlString: String, completion: @escaping (T) -> Void) {
        ForecastService.getData(urlString: urlString) { data, _, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            guard let data = data else { return }
            
            do {
                let json = try JSONDecoder().decode(T.self, from: data)
                completion(json)
            } catch {
                print(error.localizedDescription)
                print(error)
            }
        }
    }
}
