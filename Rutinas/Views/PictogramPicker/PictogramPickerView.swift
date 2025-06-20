//
//  PictogramPickerView.swift
//  Rutinas
//

import SwiftUI

struct PictogramPickerView: View {
    @Environment(\.dismiss) private var dismiss
    
    @State private var searchText = ""
    @State private var pictograms: [Pictogram] = []
    @State private var options = PictogramOptions()
    @State private var language: Language = .es
    @State private var searchType: SearchType = .search
    @State private var isLoading = false
    @State private var showOptions = false
    @State private var showAbout = false
    @State private var debouncedTask: Task<Void, Never>? = nil
    
    let onSelect: (URL) -> Void
    
    var body: some View {
        NavigationStack {
            ScrollView {
                PictogramGrid(pictograms: pictograms, options: options) { url in
                    onSelect(url)
                    dismiss()
                }
            }
            .overlay {
                if isLoading {
                    ProgressView().scaleEffect(1.4)
                }
            }
            .searchable(text: $searchText, prompt: "Search in ARASAAC…")
            .onChange(of: searchText) {
                debouncedTask?.cancel()
                debouncedTask = Task {
                    try? await Task.sleep(for: .milliseconds(400))
                    await load(for: searchText)
                }
            }
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancelar") { dismiss() }
                }
                ToolbarItem(placement: .bottomBar) {
                    Menu {
                        Picker(selection: $language) {
                            ForEach(Language.allCases) { lang in
                                Text(lang.displayName).tag(lang)
                            }
                        } label: {
                            Text("Language")
                            Text(language.displayName)
                        }
                        .pickerStyle(.menu)
                        Picker("Search mode", selection: $searchType) {
                            ForEach(SearchType.allCases) { mode in
                                Text(mode.displayName).tag(mode)
                            }
                        }
                    } label: {
                        Image(systemName: "globe")
                    }
                }
                ToolbarItem(placement: .bottomBar) {
                    Button {
                        showOptions.toggle()
                    } label: {
                        Image(systemName: "switch.2")
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showAbout.toggle()
                    } label: {
                        Image(systemName: "info.circle.fill")
                            .font(.title2)
                            .foregroundStyle(Color.accentColor, Color(.secondarySystemFill))
                    }
                    .accessibilityLabel("About")
                }
            }
            .sheet(isPresented: $showOptions) {
                PictogramOptionsView(options: $options)
            }
            .sheet(isPresented: $showAbout) {
                AboutView()
            }
            .navigationTitle("Pictograms")
            .navigationBarTitleDisplayMode(.inline)
            .task { await load(for: "") }  // carga inicial (40 newest)
        }
    }
    
    @MainActor
    private func load(for text: String) async {
        isLoading = true
        defer { isLoading = false }
        
        if text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            pictograms = (try? await ArasaacService.newest(language: language)) ?? []
        } else {
            pictograms = (try? await ArasaacService.search(language: language, text: text, searchType: searchType)) ?? []
        }
    }
}

#Preview("PictogramPickerView") {
    PictogramPickerView { _ in }
}
