import Foundation
import Combine

final class AddNoteViewModel: ObservableObject {
    @Published var text: String = ""
    @Published var isSaving: Bool = false
    @Published var errorMessage: String?
    
    private let weatherService: WeatherService
    private let storage: NotesStorageProtocol
    
    init(
        weatherService: WeatherService = .shared,
        storage: NotesStorageProtocol = NotesStorageService()
    ) {
        self.weatherService = weatherService
        self.storage = storage
    }
    
    @MainActor
    func saveNote() async -> Bool {
        let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard !trimmed.isEmpty else {
            errorMessage = "Please enter some text for your note."
            return false
        }
        
        isSaving = true
        defer { isSaving = false }
        
        do {
            let weather = try await weatherService.fetchCurrentWeather(for: "Kyiv")
            
            let newNote = WeatherNote(
                id: UUID(),
                text: trimmed,
                createdAt: Date(),
                temperatureC: weather.current.tempC,
                conditionText: weather.current.condition.text,
                iconURL: weather.current.condition.icon,
                locationName: weather.location.name
            )
            
            var existing = storage.loadNotes()
            existing.insert(newNote, at: 0)
            storage.saveNotes(existing)
            
            return true
        } catch {
            if let urlError = error as? URLError {
                switch urlError.code {
                case .notConnectedToInternet:
                    errorMessage = "No internet connection. Please check your network and try again."
                case .timedOut:
                    errorMessage = "The weather request timed out. Please try again."
                default:
                    errorMessage = "Failed to reach the weather service. Please try again."
                }
            } else if let localized = error as? LocalizedError,
                      let description = localized.errorDescription {
                errorMessage = description
            } else {
                errorMessage = "Failed to fetch weather. Please check your connection and try again."
            }
            return false
        }
    }
}


