import Foundation

struct WeatherNote: Identifiable, Codable, Equatable {
    let id: UUID
    let text: String
    let createdAt: Date
    let temperatureC: Double
    let conditionText: String
    let iconURL: String?
    let locationName: String
}
