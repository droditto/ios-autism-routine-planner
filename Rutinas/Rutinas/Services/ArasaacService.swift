//
//  ArasaacService.swift
//  Rutinas
//

import Foundation
import SwiftUI

enum SearchType: String, CaseIterable, Identifiable {
    case search = "search"
    case bestSearch = "bestsearch"
    var id: String { rawValue }
    
    var displayName: String {
        switch self {
        case .search: "Standard Search"
        case .bestSearch: "Best Search"
        }
    }
}

enum Language: String, CaseIterable, Identifiable {
    case an, ar, bg, br, ca, cs, da, de, el, en, es, et, eu, fa, fr, gl, he, hr,
         hu, it, ko, lt, lv, mk, nb, nl, pl, pt, ro, ru, sk, sq, sv, sr, tr, val, uk, zh
    
    var id: String { rawValue }
    
    var displayName: String {
        switch self {
        case .an: "Aragonese"
        case .ar: "Arabic"
        case .bg: "Bulgarian"
        case .br: "Breton"
        case .ca: "Catalan"
        case .cs: "Czech"
        case .da: "Danish"
        case .de: "German"
        case .el: "Greek"
        case .en: "English"
        case .es: "Spanish"
        case .et: "Estonian"
        case .eu: "Basque"
        case .fa: "Persian"
        case .fr: "French"
        case .gl: "Galician"
        case .he: "Hebrew"
        case .hr: "Croatian"
        case .hu: "Hungarian"
        case .it: "Italian"
        case .ko: "Korean"
        case .lt: "Lithuanian"
        case .lv: "Latvian"
        case .mk: "Macedonian"
        case .nb: "Norwegian Bokmål"
        case .nl: "Dutch"
        case .pl: "Polish"
        case .pt: "Portuguese"
        case .ro: "Romanian"
        case .ru: "Russian"
        case .sk: "Slovak"
        case .sq: "Albanian"
        case .sv: "Swedish"
        case .sr: "Serbian"
        case .tr: "Turkish"
        case .val: "Valencian"
        case .uk: "Ukrainian"
        case .zh: "Chinese"
        }
    }
}

enum ArasaacService {
    
    static func search(
        language: Language = .es,
        text: String,
        searchType: SearchType = .search
    ) async throws -> [Pictogram] {
        
        guard let encoded = text.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed),
              let url = URL(
                string:
                    "https://api.arasaac.org/v1/pictograms/\(language.rawValue)/\(searchType.rawValue)/\(encoded)"
              )
        else {
            return []
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode([Pictogram].self, from: data)
    }
    
    // Latest pictograms
    static func newest(language: Language = .es, count: Int = 48) async throws -> [Pictogram] {
        guard
            let url = URL(
                string:
                    "https://api.arasaac.org/v1/pictograms/\(language.rawValue)/new/\(count)"
            )
        else { return [] }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode([Pictogram].self, from: data)
    }
    
    // URL con las opciones
    static func imageURL(
        for id: Int,
        resolution: Int = 500,
        options: PictogramOptions,
        url: Bool = false
    ) -> URL? {
        var components = URLComponents(string: "https://api.arasaac.org/v1/pictograms/\(id)")
        var items: [URLQueryItem] = [
            .init(name: "resolution", value: "\(resolution)")
        ]
        
        if url { items.append(.init(name: "url", value: "true")) }
        if options.plural { items.append(.init(name: "plural", value: "true")) }
        if !options.color { items.append(.init(name: "color", value: "false")) }
        if let act = options.action { items.append(.init(name: "action", value: act.rawValue)) }
        if let skin = options.skin { items.append(.init(name: "skin", value: skin.rawValue)) }
        if let hair = options.hair { items.append(.init(name: "hair", value: hair.rawValue)) }
        if let idf = options.identifier {
            items.append(.init(name: "identifier", value: idf.rawValue))
            items.append(
                .init(name: "identifierPosition", value: options.identifierPosition.rawValue))
        }
        
        components?.queryItems = items
        return components?.url
    }
}
