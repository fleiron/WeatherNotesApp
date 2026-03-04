
import Foundation

final class WeatherService {
    static let shared = WeatherService()
    private init() {}

    private let apiKey = "50b2311d2e9bbe6e35eb85950ffae043"
    
    enum WeatherServiceError: Error, LocalizedError {
        case invalidURL
        case badResponse(statusCode: Int)
        case decodingError
        case missingAPIKey
        
        var errorDescription: String? {
            switch self {
            case .invalidURL:
                return "Invalid URL."
            case .badResponse(let statusCode):
                return "Bad response: \(statusCode)."
            case .decodingError:
                return "Failed to decode weather data."
            case .missingAPIKey:
                return "Missing WeatherAPI key."
            }
        }
    }
    
    func fetchCurrentWeather(for city: String) async throws -> WeatherAPIResponse {
        guard !apiKey.isEmpty, apiKey != "YOUR_API_KEY_HERE" else {
            throw WeatherServiceError.missingAPIKey
        }
        
        var components = URLComponents(string: "https://api.weatherapi.com/v1/current.json")
        components?.queryItems = [
            .init(name: "key", value: apiKey),
            .init(name: "q", value: city),
            .init(name: "aqi", value: "no")
        ]
        
        guard let url = components?.url else {
            throw WeatherServiceError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        if let http = response as? HTTPURLResponse,
           !(200...299).contains(http.statusCode) {
            throw WeatherServiceError.badResponse(statusCode: http.statusCode)
        }
        
        do {
            let decoded = try JSONDecoder().decode(WeatherAPIResponse.self, from: data)
            return decoded
        } catch {
            throw WeatherServiceError.decodingError
        }
    }
}
