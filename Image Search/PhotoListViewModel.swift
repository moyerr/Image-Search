//
//  PhotoListViewModel.swift
//  Image Search
//
//  Created by Robert Moyer on 2/24/23.
//

import AsyncAlgorithms
import Foundation

@MainActor
final class PhotoListViewModel: ObservableObject {
    @Published var photos: [Photo] = []
    @Published var errorMessage: String?
    @Published var isLoading = false

    private var continuation: AsyncStream<Void>.Continuation?

    var loadingText: String {
        photos.isEmpty ? "Loading..." : "Loading More Results..."
    }

    func searchPhotos(_ searchTerm: String) {
        let photoSearch = PagedPhotoSearch(searchTerm: searchTerm)
            .yeilded { continuation in
                self.continuation = continuation
            }

        Task {
            do {
                for try await batch in photoSearch {
                    Log.view.debug("Reached inside for loop")
                    isLoading = false
                    self.photos += batch
                }
            } catch {
                errorMessage = error.localizedDescription
            }
        }

        loadMore()
    }

    func loadMoreIfNeeded(currentItem: Photo) {
        if currentItem.id == photos.last?.id {
            loadMore()
        }
    }

    private func loadMore() {
        guard !isLoading else { return }
        let continuationNil = "\(continuation == nil)"
        Log.view.debug("PhotoListViewModel.loadMore() | \(continuationNil)")
        isLoading = true
        continuation?.yield()
    }
}
