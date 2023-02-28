//
//  Endpoint.swift
//  Image Search
//
//  Created by Robert Moyer on 2/28/23.
//

import Foundation

// MARK: - Endpoint

struct Endpoint {
    let urlBuilder: URLBuilder
    let headerPolicy: HeaderPolicy
    let method: HTTPMethod

    var urlRequest: URLRequest {
        let url = urlBuilder.buildURL()
        var request = URLRequest(url: url)

        switch method {
        case .put(let data), .post(let data):
            request.httpBody = data
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        case .get(let queryItems), .delete(let queryItems):
            guard !queryItems.isEmpty else { break }

            var components = URLComponents(url: url, resolvingAgainstBaseURL: false)
            let newQueryItems = (components?.queryItems ?? []) + queryItems
            components?.queryItems = newQueryItems

            guard let url = components?.url
            else { preconditionFailure("Couldn't create url from components.") }

            request = URLRequest(url: url)
        }

        for header in headerPolicy.makeHTTPHeaders() {
            request.setValue(
                header.value,
                forHTTPHeaderField: header.key
            )
        }

        request.httpMethod = method.name

        return request
    }
}

// MARK: - Endpoint Definitions

extension Endpoint {
    static func search(_ searchTerm: String) -> Endpoint {
        .init(
            urlBuilder: .pexels("search"),
            headerPolicy: PexelHeaderPolicy(),
            method: .get([URLQueryItem(name: "query", value: searchTerm)])
        )
    }

    static func pageAfter(_ page: Page) -> Endpoint? {
        guard let nextPage = page.nextPage else { return nil }

        return .init(
            urlBuilder: .just(nextPage),
            headerPolicy: PexelHeaderPolicy(),
            method: .get
        )
    }
}
