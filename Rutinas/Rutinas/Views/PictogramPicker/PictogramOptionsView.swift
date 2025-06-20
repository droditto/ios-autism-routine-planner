//
//  PictogramOptionsView.swift
//  Rutinas
//

import SwiftUI

struct PictogramOptionsView: View {
    @Binding var options: PictogramOptions
    @Environment(\.dismiss) private var dismiss
    
    private var pluralToggle: Binding<Bool> {
        Binding {
            options.plural
        } set: { newValue in
            options.plural = newValue
            if newValue {
                options.action = nil
                options.identifier = nil
            }
        }
    }
    
    private var actionToggle: Binding<Bool> {
        Binding {
            options.action != nil
        } set: { newValue in
            if newValue {
                options.action = options.action ?? .past  // valor por defecto
                options.plural = false
                options.identifier = nil
            } else {
                options.action = nil
            }
        }
    }
    
    private var identifierToggle: Binding<Bool> {
        Binding {
            options.identifier != nil
        } set: { newValue in
            if newValue {
                options.identifier = options.identifier ?? .classroom
                options.plural = false
                options.action = nil
            } else {
                options.identifier = nil
            }
        }
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section(
                    header: Text("Color"),
                    footer: Text("Turn off to display the pictograms in black and white.")
                ) {
                    Toggle("Color", isOn: $options.color)
                }
                
                Section(
                    header: Text("Symbols"),
                    footer: Text(
                        "Add a symbol to the pictograms. Only one can be added at a time.")
                ) {
                    Toggle(isOn: pluralToggle) {
                        Text("Plural")
                    }
                    Toggle(isOn: actionToggle) {
                        Text("Action")
                    }
                    Picker(
                        "Status",
                        selection: Binding(
                            get: { options.action ?? .past },
                            set: { options.action = $0 }
                        )
                    ) {
                        ForEach(PictogramOptions.Action.allCases) {
                            Text($0.rawValue.capitalized).tag($0)
                        }
                    }
                    .pickerStyle(.navigationLink)
                    .disabled(options.action == nil)
                    
                    // Identifier
                    Toggle(isOn: identifierToggle) {
                        Text("Identifier")
                    }
                    Picker(
                        "Type",
                        selection: Binding(
                            get: { options.identifier ?? .classroom },
                            set: { options.identifier = $0 }
                        )
                    ) {
                        ForEach(PictogramOptions.Identifier.allCases) {
                            Text($0.rawValue.capitalized).tag($0)
                        }
                    }
                    .pickerStyle(.navigationLink)
                    .disabled(options.identifier == nil)
                    
                    Picker("Position", selection: $options.identifierPosition) {
                        ForEach(PictogramOptions.IdentifierPosition.allCases) {
                            Text($0.rawValue.capitalized).tag($0)
                        }
                    }
                    .pickerStyle(.navigationLink)
                    .disabled(options.identifier == nil)
                }
                
                // Appearance
                Section(header: Text("Appearance")) {
                    Picker("Skin tone", selection: $options.skin) {
                        Text("Default").tag(PictogramOptions.Skin?.none)
                        ForEach(PictogramOptions.Skin.allCases) {
                            Text($0.displayName).tag(Optional($0))
                        }
                    }
                    .pickerStyle(.navigationLink)
                    Picker("Hair color", selection: $options.hair) {
                        Text("Default").tag(PictogramOptions.Hair?.none)
                        ForEach(PictogramOptions.Hair.allCases) {
                            Text($0.displayName).tag(Optional($0))
                        }
                    }
                    .pickerStyle(.navigationLink)
                }
            }
            .navigationTitle("Options")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") { dismiss() }
                }
            }
        }
    }
}

#Preview("PictogramOptionsView") {
    @Previewable @State var opts = PictogramOptions()
    return NavigationStack {
        PictogramOptionsView(options: $opts)
    }
}
