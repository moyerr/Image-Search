//
//  URLBuilder.swift
//  Image Search
//
//  Created by Robert Moyer on 2/28/23.
//

import Foundation

// MARK: URLBuilder

protocol URLBuilder {
  func buildURL() -> URL
}

// MARK: PexelURLBuilder

struct PexelURLBuilder: URLBuilder {
    let path: String

    func buildURL() -> URL {
        let baseURL = URL("https://api.pexels.com/v1")
        return baseURL.appending(path: path)
    }
}

// MARK: BasicURLBuilder

struct BasicURLBuilder: URLBuilder {
    let url: URL
    func buildURL() -> URL { url }
}

// MARK: - Convenience Helpers

extension URLBuilder where Self == BasicURLBuilder {
    static func just(_ url: URL) -> BasicURLBuilder {
        .init(url: url)
    }
}

extension URLBuilder where Self == PexelURLBuilder {
    static func pexels(_ path: String) -> PexelURLBuilder {
        .init(path: path)
    }
}
