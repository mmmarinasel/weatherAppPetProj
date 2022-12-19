import Foundation

protocol ILoadable {
    static func getJson<T: Codable>(urlString: String, completion: @escaping (T) -> Void)
}

protocol IPicLoadable {
    func getImgByUrl()
}

class Loader: ILoadable {
    
    static let weatherForecastUrl = "https://api.weatherapi.com/v1/forecast.json?key=ae5d9a6d0f044d30abb231756221712&q=Warsaw&days=2"
    
    private static func getData(urlString: String, completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
        guard let url = URL(string: urlString) else { return }
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    static func getJson<T: Codable>(urlString: String, completion: @escaping (T) -> Void) {
        Loader.getData(urlString: urlString) { data, _, error in
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
