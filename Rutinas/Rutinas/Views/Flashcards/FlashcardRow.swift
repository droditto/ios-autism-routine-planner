//
//  FlashcardRow.swift
//  Rutinas
//

import SwiftUI
import Kingfisher

struct FlashcardRow: View {
    let flashcard: Flashcard
    let showIndex: Bool
    
    init(flashcard: Flashcard, showIndex: Bool = false) {
        self.flashcard = flashcard
        self.showIndex = showIndex
    }
    
    var body: some View {
        HStack(spacing: 20) {
            if showIndex {
                Text("\(flashcard.index + 1)")
                    .foregroundColor(.secondary)
            }
            
            KFImage(flashcard.imageURL)
                .resizable()
                .aspectRatio(1, contentMode: .fill)
                .frame(width: 50, height: 50)
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .shadow(radius: 1)
            
            Text(flashcard.text)
                .lineLimit(1)
        }
    }
}

#Preview {
    FlashcardRow(flashcard: SampleData.shared.flashcard)
}
