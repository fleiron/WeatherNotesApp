import SwiftUI

struct NoteDetailView: View {
    let note: WeatherNote
    
    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter
    }()
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                HStack(spacing: 16) {
                    if let iconPath = note.iconURL,
                       let url = URL(string: "https:\(iconPath)") {
                        AsyncImage(url: url) { phase in
                            switch phase {
                            case .success(let image):
                                image
                                    .resizable()
                                    .scaledToFit()
                            case .failure(_):
                                Image(systemName: "cloud.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .foregroundStyle(.secondary)
                            case .empty:
                                ProgressView()
                            @unknown default:
                                EmptyView()
                            }
                        }
                        .frame(width: 80, height: 80)
                    } else {
                        Image(systemName: "cloud.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 80, height: 80)
                            .foregroundStyle(.secondary)
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("\(note.temperatureC, specifier: "%.1f")°C")
                            .font(.rubik(40))
                        
                        Text(note.conditionText)
                            .font(.rubik(16))
                            .foregroundStyle(.secondary)
                        
                        Text(note.locationName)
                            .font(.rubik(14))
                    }
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Note")
                        .font(.rubik(16))
                    Text(note.text)
                        .font(.rubik(14))
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Date & Time")
                        .font(.rubik(16))
                    Text(Self.dateFormatter.string(from: note.createdAt))
                        .font(.rubik(14))
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
        }
        .navigationTitle("Details")
        .navigationBarTitleDisplayMode(.inline)
    }
}

