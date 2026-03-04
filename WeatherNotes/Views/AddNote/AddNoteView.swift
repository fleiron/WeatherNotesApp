import SwiftUI

struct AddNoteView: View {
    @StateObject private var viewModel: AddNoteViewModel
    @Environment(\.dismiss) private var dismiss
    
    init(viewModel: AddNoteViewModel = AddNoteViewModel()) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        ZStack {
            Color(.systemBackground)
                .ignoresSafeArea()
            
            VStack(spacing: 24) {
                header
                noteField
                Spacer()
                saveButton
            }
            .padding(20)
            
            if viewModel.isSaving {
                Color.black.opacity(0.25)
                    .ignoresSafeArea()
                ProgressView()
                    .tint(.white)
            }
        }
        .alert("Error", isPresented: Binding(
            get: { viewModel.errorMessage != nil },
            set: { _ in viewModel.errorMessage = nil }
        )) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(viewModel.errorMessage ?? "")
        }
    }
    
    private var header: some View {
        HStack(alignment: .center, spacing: 16) {
            VStack(alignment: .leading, spacing: 4) {
                Text("New Note")
                    .font(.rubik(24))
                Text("Weather will be attached automatically.")
                    .font(.rubik(12))
                    .foregroundStyle(.secondary)
            }
            
            Spacer()
            
            Button {
                dismiss()
            } label: {
                Image(systemName: "xmark")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(.primary)
                    .frame(width: 32, height: 32)
                    .background(
                        Circle()
                            .fill(Color(.secondarySystemBackground))
                    )
                    .shadow(color: Color.black.opacity(0.15), radius: 6, x: 0, y: 3)
            }
            .accessibilityLabel("Close")
        }
    }
    
    private var noteField: some View {
        ZStack(alignment: .topLeading) {
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(Color(.secondarySystemBackground))
            
            TextEditor(text: $viewModel.text)
                .scrollContentBackground(.hidden)
                .padding(12)
                .font(.rubik(15))
            
            if viewModel.text.isEmpty {
                Text("Type your note...")
                    .foregroundStyle(.secondary)
                    .font(.rubik(15))
                    .padding(16)
            }
        }
        .frame(minHeight: 110)
    }
    
    private var saveButton: some View {
        Button {
            Task {
                let success = await viewModel.saveNote()
                if success {
                    dismiss()
                }
            }
        } label: {
            Text(viewModel.isSaving ? "Saving..." : "Save")
                .font(.rubik(17))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .background(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color.blue,
                            Color.purple
                        ]),
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .cornerRadius(20)
                .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 4)
        }
        .disabled(viewModel.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || viewModel.isSaving)
    }
}

struct AddNoteView_Previews: PreviewProvider {
    static var previews: some View {
        AddNoteView(viewModel: AddNoteViewModel())
    }
}

//
//  AddNoteView.swift
//  WeatherNotes
//
//  Created by Ilya on 04.03.2026.
//

