//
//  NetworkClient.swift
//  Image Search
//
//  Created by Robert Moyer on 3/1/23.
//

import Foundation

struct NetworkClient {
    private let session = URLSession.shared
    private let decoder = JSONDecoder()

    func model<Model: Decodable>(
        for endpoint: Endpoint
    ) async throws -> Model {
        let request = endpoint.urlRequest

        Log.network.info("Making request to \(request.url?.absoluteString ?? "NO_URL")")

        do {
            try await Task.sleep(for: .seconds(3))
            let (data, _) = try await session.data(for: endpoint.urlRequest)
            Log.network.info("Request completed successfully! Received \(data.description)")
            return try data.decoded(using: decoder)
        } catch {
            Log.network.error("ERROR: \(error.localizedDescription)")
            throw error
        }
    }
}
