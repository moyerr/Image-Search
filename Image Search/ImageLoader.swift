//
//  ImageLoader.swift
//  Image Search
//
//  Created by Robert Moyer on 2/16/23.
//

import UIKit

struct NetworkClient {
    private let session = URLSession.shared
    private let decoder = JSONDecoder()

    func model<Model: Decodable>(
        for endpoint: Endpoint
    ) async throws -> Model {
        let request = endpoint.urlRequest

        Log.network.info("Making request to \(request.url?.absoluteString ?? "NO_URL")")

        do {
            let (data, _) = try await session.data(for: endpoint.urlRequest)
            Log.network.info("Request completed successfully! Received \(data.description)")
            return try data.decoded(using: decoder)
        } catch {
            Log.network.error("ERROR: \(error.localizedDescription)")
            throw error
        }
    }
}

struct PhotoClient {
    private let networkClient = NetworkClient()

    func search(_ searchTerm: String) -> AsyncThrowingStream<Page, Error> {
        var currentPage: Page?

        return AsyncThrowingStream {
            Log.stream.debug("Executing stream closure for page \(currentPage?.page ?? 0)")

            guard let lastPage = currentPage else {
                Log.stream.debug("\tPerforming initial fetch")
                currentPage = try await networkClient.model(for: .search(searchTerm))
                return currentPage
            }

            if let nextPage = Endpoint.pageAfter(lastPage) {
                Log.stream.debug("\tFetching next page...")
                currentPage = try await networkClient.model(for: nextPage)
                return currentPage
            } else {
                Log.stream.debug("\tNo more pages!")
                return nil
            }
        }
    }
}

struct PagedPhotoSearch: AsyncSequence {
    typealias Element = [Photo]

    struct AsyncIterator: AsyncIteratorProtocol {
        private var _next: () async throws -> [Photo]?

        init<S: AsyncSequence>(_ sequence: S) where S.Element == Element {
            var iterator = sequence.makeAsyncIterator()
            self._next = { try await iterator.next() }
        }

        mutating func next() async throws -> [Photo]? {
            try await _next()
        }
    }

    let searchTerm: String

    func makeAsyncIterator() -> AsyncIterator {
        AsyncIterator(
            makePageStream()
                .map(\.photos)
        )
    }

    private func makePageStream() -> AsyncThrowingStream<Page, Error> {
        let networkClient = NetworkClient()
        var currentPage: Page?

        return AsyncThrowingStream {
            // This closure is called once for every iteration of the sequence
            Log.stream.debug("Executing stream closure for page \((currentPage?.page ?? 0) + 1)")

            guard let lastPage = currentPage else {
                Log.stream.debug("\tPerforming initial fetch")
                currentPage = try await networkClient.model(for: .search(searchTerm))
                return currentPage
            }

            if let nextPage = Endpoint.pageAfter(lastPage) {
                Log.stream.debug("\tFetching next page...")
                currentPage = try await networkClient.model(for: nextPage)
                return currentPage
            } else {
                Log.stream.debug("\tNo more pages!")
                return nil
            }
        }
    }
}
