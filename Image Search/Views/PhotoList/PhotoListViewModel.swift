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

    private var continuation: AsyncDemandSequence.Continuation?

    var loadingText: String {
        photos.isEmpty ? "Loading..." : "Loading More Results..."
    }

    func searchPhotos(_ searchTerm: String) {
        let photoSearch = PagedPhotoSearch(searchTerm: searchTerm)
            .demanded { continuation in
                self.continuation = continuation
            }

        Task {
            do {
                for try await batch in photoSearch {
                    Log.view.debug("PhotoListViewModel - Received new batch of photos")
                    isLoading = false
                    self.photos += batch
                }
            } catch {
                errorMessage = error.localizedDescription
            }
        }

        loadMoreIfNeeded(currentItem: nil)
    }

    func loadMoreIfNeeded(currentItem: Photo?) {
        guard
            !isLoading,                         // Only request more if loading is not in progress
            currentItem?.id == photos.last?.id  // Only request more if we have reached the last item
        else { return }

        Log.view.debug("PhotoListViewModel - Reached last item. Loading more...")

        isLoading = true
        continuation?.yield()
    }
}
