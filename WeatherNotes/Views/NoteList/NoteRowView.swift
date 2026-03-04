import SwiftUI

struct NoteRowView: View {
    let note: WeatherNote
    
    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter
    }()
    
    var body: some View {
        HStack(spacing: 12) {
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
                .frame(width: 40, height: 40)
            } else {
                Image(systemName: "cloud.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 40, height: 40)
                    .foregroundStyle(.secondary)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(note.text)
                    .font(.rubik(17))
                    .lineLimit(2)
                
                Text(Self.dateFormatter.string(from: note.createdAt))
                    .font(.rubik(11))
                    .foregroundStyle(.secondary)
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 4) {
                Text("\(note.temperatureC, specifier: "%.1f")°C")
                    .font(.rubik(17))
                Text(note.conditionText)
                    .font(.rubik(11))
                    .foregroundStyle(.secondary)
            }
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(Color(.secondarySystemBackground))
        )
        .shadow(color: Color.black.opacity(0.08), radius: 8, x: 0, y: 4)
    }
}

struct NoteRowView_Previews: PreviewProvider {
    static var previews: some View {
        NoteRowView(
            note: WeatherNote(
                id: UUID(),
                text: "Run in the park",
                createdAt: .now,
                temperatureC: 18.5,
                conditionText: "Clear",
                iconURL: "//cdn.weatherapi.com/weather/64x64/day/113.png",
                locationName: "Kyiv"
            )
        )
        .previewLayout(.sizeThatFits)
        .padding()
    }
}

