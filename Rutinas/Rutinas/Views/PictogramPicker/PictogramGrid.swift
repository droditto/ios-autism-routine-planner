//
//  PictogramGrid.swift
//  Rutinas
//

import SwiftUI
import Kingfisher

struct PictogramGrid: View {
    let pictograms: [Pictogram]
    let options: PictogramOptions
    let onSelect: (URL) -> Void
    
    // Tres columnas
    private let columns = Array(repeating: GridItem(.flexible(), spacing: 2), count: 3)
    
    var body: some View {
        LazyVGrid(columns: columns, spacing: 2) {
            ForEach(pictograms) { pic in
                if let url = ArasaacService.imageURL(for: pic.id, options: options) {
                    KFImage(url)
                        .resizable()
                        .aspectRatio(1, contentMode: .fill)
                        .background(Color.white)
                        .clipped()
                        .onTapGesture {
                            onSelect(url)
                        }
                }
            }
        }
    }
}

#Preview("PictogramGrid") {
    let pictograms: [Pictogram] = (1...24).map { idx in
        Pictogram(id: 38000 + idx)
    }
    ScrollView {
        PictogramGrid(pictograms: pictograms, options: .init()) { _ in }
    }
}
