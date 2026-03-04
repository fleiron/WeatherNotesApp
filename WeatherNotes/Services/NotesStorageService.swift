import Foundation

protocol NotesStorageProtocol {
    func loadNotes() -> [WeatherNote]
    func saveNotes(_ notes: [WeatherNote])
}

final class NotesStorageService: NotesStorageProtocol {
    private let userDefaults: UserDefaults
    private let storageKey = "weather_notes_storage_key"
    
    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
    }
    
    func loadNotes() -> [WeatherNote] {
        guard let data = userDefaults.data(forKey: storageKey) else {
            return []
        }
        
        do {
            let notes = try JSONDecoder().decode([WeatherNote].self, from: data)
            return notes
        } catch {
            return []
        }
    }
    
    func saveNotes(_ notes: [WeatherNote]) {
        do {
            let data = try JSONEncoder().encode(notes)
            userDefaults.set(data, forKey: storageKey)
        } catch {
            // In this simple demo we silently ignore save errors.
        }
    }
}

