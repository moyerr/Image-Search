//
//  Page.swift
//  Image Search
//
//  Created by Robert Moyer on 2/24/23.
//

import Foundation

struct Page: Decodable {
    private enum CodingKeys: String, CodingKey {
        case page, photos
        case resultsPerPage = "per_page"
        case totalResults = "total_results"
        case nextPage = "next_page"
    }

    let page: Int
    let resultsPerPage: Int
    let photos: [Photo]
    let totalResults: Int
    let nextPage: URL?
}
