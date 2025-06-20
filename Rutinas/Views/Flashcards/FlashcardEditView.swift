//
//  FlashcardEditView.swift
//  Rutinas
//

import SwiftUI
import Kingfisher

struct FlashcardEditView: View {
    @Environment(\.dismiss) private var dismiss
    var onAdd: (String, URL) -> Void
    
    @State private var text: String = ""
    @State private var imageURL: URL?
    @State private var showPicker = false
    
    var body: some View {
        NavigationStack {
            List {
                // Header
                VStack {
                    Button { showPicker = true } label: {
                        ZStack {
                            if let url = imageURL {
                                KFImage(url)
                                    .resizable()
                                    .aspectRatio(1, contentMode: .fill)
                                    .background(Color.white)
                                    .clipShape(RoundedRectangle(cornerRadius: 12))
                                    .shadow(radius: 1)
                                    .padding(4)
                            } else {
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color(.tertiarySystemFill))
                                Image(systemName: "camera.circle.fill")
                                    .font(.system(size: 40, weight: .bold))
                                    .foregroundStyle(Color.accentColor)
                            }
                        }
                        .frame(width: 200, height: 200)
                    }
                    .buttonStyle(.plain)
                    
                    TextField("Flashcard Text", text: $text)
                        .font(.title.bold())
                        .lineLimit(1)
                        .multilineTextAlignment(.center)
                        .padding(.vertical, 16)
                }
                .frame(maxWidth: .infinity, alignment: .center)
                .listRowSeparator(.hidden)
                
            }
            .listStyle(.plain)
            .navigationTitle("New Flashcard")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Add") {
                        guard let url = imageURL, !text.trimmingCharacters(in: .whitespaces).isEmpty else { return }
                        onAdd(text, url)
                    }
                    .disabled(imageURL == nil || text.trimmingCharacters(in: .whitespaces).isEmpty)
                }
            }
            .sheet(isPresented: $showPicker) {
                PictogramPickerView { url in
                    imageURL = url
                    showPicker = false
                }
            }
        }
    }
}

#Preview {
    FlashcardEditView { _, _ in }
}
