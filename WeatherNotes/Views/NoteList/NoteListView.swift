import SwiftUI

struct NoteListView: View {
    @StateObject private var viewModel: NoteListViewModel
    @State private var isPresentingAddNote = false
    
    init(viewModel: NoteListViewModel = NoteListViewModel()) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color.blue.opacity(0.6),
                        Color.purple.opacity(0.7)
                    ]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                VStack(spacing: 20) {
                    header
                    content
                }
                .padding(.horizontal, 20)
                .padding(.top, 16)
                .padding(.bottom, 8)
            }
            .toolbar(.hidden, for: .navigationBar)
        }
        .sheet(isPresented: $isPresentingAddNote, onDismiss: {
            viewModel.loadNotes()
        }) {
            AddNoteView()
        }
    }
    
    private var header: some View {
        HStack(alignment: .center, spacing: 16) {
            VStack(alignment: .leading, spacing: 4) {
                Text("Weather Notes")
                    .font(.rubik(28))
                    .foregroundStyle(.white)
                Text("Save your moments with weather.")
                    .font(.rubik(12))
                    .foregroundStyle(.white.opacity(0.8))
            }
            
            Spacer()
            
            Button {
                isPresentingAddNote = true
            } label: {
                Image(systemName: "plus")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.white)
                    .frame(width: 40, height: 40)
                    .background(
                        Circle()
                            .fill(Color.white.opacity(0.25))
                    )
                    .overlay(
                        Circle()
                            .strokeBorder(Color.white.opacity(0.6), lineWidth: 1)
                    )
                    .shadow(color: Color.black.opacity(0.25), radius: 8, x: 0, y: 4)
            }
            .accessibilityLabel("Add note")
            .padding(.top, 6)
        }
    }
    
    @ViewBuilder
    private var content: some View {
        if viewModel.notes.isEmpty {
            VStack(spacing: 16) {
                Image(systemName: "cloud.sun.fill")
                    .font(.system(size: 52))
                    .symbolRenderingMode(.palette)
                    .foregroundStyle(.yellow, .white)
                
                Text("No notes yet")
                    .font(.rubik(22))
                    .foregroundStyle(.white)
                
                Text("Add your first note to see it here.")
                    .font(.rubik(14))
                    .foregroundStyle(.white.opacity(0.8))
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding()
        } else {
            List {
                ForEach(viewModel.notes) { note in
                    NavigationLink {
                        NoteDetailView(note: note)
                    } label: {
                        NoteRowView(note: note)
                    }
                }
                .onDelete(perform: viewModel.deleteNotes)
            }
            .listStyle(.insetGrouped)
            .scrollContentBackground(.hidden)
            .background(Color.clear)
        }
    }
}

