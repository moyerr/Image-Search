//
//  HeaderPolicy.swift
//  Image Search
//
//  Created by Robert Moyer on 2/28/23.
//

import Foundation

// MARK: HeaderPolicy

protocol HeaderPolicy {
  func makeHTTPHeaders() -> [String: String]
}

// MARK: PexelHeaderPolicy

struct PexelHeaderPolicy: HeaderPolicy {
  @Secret(\.apiKey) private var key

  func makeHTTPHeaders() -> [String: String] {
    [
      "Authorization": key,
      "Content-Type": "application/json"
    ]
  }
}

// MARK: NoHeaderPolicy

struct NoHeaderPolicy: HeaderPolicy {
  func makeHTTPHeaders() -> [String : String] { [:] }
}
