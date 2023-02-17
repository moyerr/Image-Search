//
//  Photo.swift
//  Image Search
//
//  Created by Robert Moyer on 2/16/23.
//

import Foundation

struct Photographer: Identifiable, Decodable {
    fileprivate enum CodingKeys: String, CodingKey {
        case id = "photographer_id"
        case name = "photographer"
        case url = "photographer_url"
    }

    let id: Int
    let name: String
    let url: URL
}

struct Photo: Identifiable {
    struct Source: Decodable {
        let original: URL
        let large2x: URL
        let large: URL
        let medium: URL
        let small: URL
        let portrait: URL
        let landscape: URL
        let tiny: URL
    }

    let id: Int
    let width: Int
    let height: Int
    let url: URL
    let photographer: Photographer
    let averageColor: String
    let source: Source
    let liked: Bool
    let altText: String
}

extension Photo: Decodable {
    private enum CodingKeys: String, CodingKey {
        case id, width, height, url, liked
        case averageColor = "avg_color"
        case source = "src"
        case altText = "alt"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.id = try container.decode(Int.self, forKey: .id)
        self.width = try container.decode(Int.self, forKey: .width)
        self.height = try container.decode(Int.self, forKey: .height)
        self.url = try container.decode(URL.self, forKey: .url)
        self.photographer = try Photographer(from: decoder)
        self.averageColor = try container.decode(String.self, forKey: .averageColor)
        self.source = try container.decode(Source.self, forKey: .source)
        self.liked = try container.decode(Bool.self, forKey: .liked)
        self.altText = try container.decode(String.self, forKey: .altText)
    }
}
