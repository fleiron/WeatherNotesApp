import Foundation
import Combine
import SwiftUI

final class NoteListViewModel: ObservableObject {
    @Published private(set) var notes: [WeatherNote] = []
    @Published var errorMessage: String?
    
    private let storage: NotesStorageProtocol
    
    init(storage: NotesStorageProtocol = NotesStorageService()) {
        self.storage = storage
        loadNotes()
    }
    
    func loadNotes() {
        notes = storage.loadNotes()
    }
    
    func deleteNotes(at offsets: IndexSet) {
        notes.remove(atOffsets: offsets)
        storage.saveNotes(notes)
    }
}

