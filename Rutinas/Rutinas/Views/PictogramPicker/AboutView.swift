//
//  AboutView.swift
//  Rutinas
//

import SwiftUI

struct AboutView: View {
    @Environment(\.dismiss) private var dismiss
    
    private let licenseText = """
        The pictographic symbols used are the property of the Government of Aragón and have been created by Sergio Palao for ARASAAC (http://www.arasaac.org), that distributes them under Creative Commons License BY-NC-SA.
        """
    
    var body: some View {
        NavigationView {
            VStack {
                Text(.init(licenseText))
                    .padding()
                    .font(.body)
                
                Spacer()
                
                Image("logo_ARASAAC")
                    .resizable()
                    .scaledToFit()
                    .padding()
            }
            .navigationTitle("About ARASAAC")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    AboutView()
}
