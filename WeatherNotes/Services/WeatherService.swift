
import Foundation

final class WeatherService {
    static let shared = WeatherService()
    private init() {}

    private let apiKey = AppConfig.weatherApiKey
    
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
                switch statusCode {
                case 401:
                    return "Weather request was not authorized (401). Please check your API key."
                case 500...599:
                    return "Weather service is temporarily unavailable. Please try again later."
                default:
                    return "Unexpected weather service response (\(statusCode)). Please try again."
                }
            case .decodingError:
                return "Failed to decode weather data."
            case .missingAPIKey:
                return "Weather service is not configured. Please provide a valid API key."
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
