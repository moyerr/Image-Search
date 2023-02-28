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
    private let apiKey = "kV1T51p7Nfud9vdnLhogcGFBOYpb8HMWdCtRjVbDmztRL4tBDMbzhNip"

    func makeHTTPHeaders() -> [String: String] {
        [
            "Authorization": apiKey,
            "Content-Type": "application/json"
        ]
    }
}

// MARK: NoHeaderPolicy

struct NoHeaderPolicy: HeaderPolicy {
    func makeHTTPHeaders() -> [String : String] { [:] }
}
