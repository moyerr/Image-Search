//
//  PagedPhotoSearch.swift
//  Image Search
//
//  Created by Robert Moyer on 2/16/23.
//

import Foundation

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
      let pageNumber = currentPage?.page ?? 0

      Log.sequence.debug("PagedPhotoSearch - Executing closure for page \(pageNumber + 1)")

      guard let lastPage = currentPage else {
        // 1️⃣ - If there is no currentPage, execute the first search
        currentPage = try await networkClient.model(for: .search(searchTerm))
        return currentPage
      }

      if let nextPage = Endpoint.pageAfter(lastPage) {
        // 2️⃣ - If the current page has a next page, fetch it
        currentPage = try await networkClient.model(for: nextPage)
        return currentPage
      } else {
        // 3️⃣ - If there is no next page, we have reached the end of the AsyncSequence.
        //      The sequence is terminated by returning nil.
        return nil
      }
    }
  }
}
