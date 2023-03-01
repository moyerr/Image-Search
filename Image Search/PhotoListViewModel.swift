//
//  PhotoListViewModel.swift
//  Image Search
//
//  Created by Robert Moyer on 2/24/23.
//

import Foundation

@MainActor
final class PhotoListViewModel: ObservableObject {
    enum Error: Swift.Error {
        case sequenceCompleted
        case noSearch
    }

    @Published var photos: [Photo] = []
    @Published var errorMessage: String?
    @Published private var loadingTask: Task<[Photo], Swift.Error>?

    private var iterate: () async throws -> [Photo] = { throw Error.noSearch }

    var isLoadingMoreContent: Bool { loadingTask != nil }
    var loadingText: String {
        photos.isEmpty ? "Loading..." : "Loading More Results..."
    }

    func searchPhotos(_ searchTerm: String) {
        var iterator = PagedPhotoSearch(searchTerm: searchTerm)
            .makeAsyncIterator()

        iterate = {
            guard let nextBatch = try await iterator.next() else {
                throw Error.sequenceCompleted
            }

            return nextBatch
        }

        loadMoreIfNeeded(current: nil)
    }

    func loadMoreIfNeeded(current: Photo?) {
        guard let current else {
            Task { await loadMore() }
            return
        }

        if current.id == photos.last?.id {
            Task { await loadMore() }
        }
    }

    private func loadMore() async {
        guard !isLoadingMoreContent else { return }

        let task = Task {
            try await Task.sleep(for: .seconds(3))
            return try await iterate()
        }
        
        loadingTask = task

        do {
            photos += try await task.value
        } catch {
            errorMessage = error.localizedDescription
        }

        loadingTask = nil
    }
}
