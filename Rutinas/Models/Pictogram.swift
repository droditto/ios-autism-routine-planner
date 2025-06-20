//
//  Pictogram.swift
//  Rutinas
//

import Foundation

struct Pictogram: Identifiable, Codable {
    let id: Int
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
    }
    
    private static let baseURL = URL(string: "https://api.arasaac.org/api/pictograms")!
    
    var url: URL {
        Pictogram.baseURL.appendingPathComponent("\(id)")
    }
}
