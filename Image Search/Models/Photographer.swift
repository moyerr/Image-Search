//
//  Photographer.swift
//  Image Search
//
//  Created by Robert Moyer on 2/24/23.
//

import Foundation

struct Photographer: Identifiable, Decodable {
    private enum CodingKeys: String, CodingKey {
        case id = "photographer_id"
        case name = "photographer"
        case url = "photographer_url"
    }

    let id: Int
    let name: String
    let url: URL
}
