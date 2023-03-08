//
//  PhotoSearchViewModel.swift
//  Image Search
//
//  Created by Robert Moyer on 2/24/23.
//

import AsyncAlgorithms
import Foundation

@MainActor
final class PhotoSearchViewModel: ObservableObject {
  @Published var searchText = ""
  @Published var photos: [Photo] = []
  @Published var errorMessage: String?
  @Published var isLoading = false

  private var continuation: AsyncDemandSequence.Continuation?
  private var searchTask: Task<Void, Never>?

  var loadingText: String {
    photos.isEmpty ? "Loading..." : "Loading More Results..."
  }

  init() { monitorSearchTerm() }

  private func monitorSearchTerm() {
    let searchTerms = $searchText.values
      .debounce(for: .seconds(0.5))

    Task { [weak self] in
      
      for await term in searchTerms {
        guard let self else { return }
        guard !term.isEmpty else { continue }

        Log.view.debug("PhotoSearchViewModel - Received new search term \(term)")

        self.searchTask?.cancel()
        self.photos = []
        self.isLoading = false

        self.searchPhotos(term)
      }
    }
  }

  private func searchPhotos(_ searchTerm: String) {
    let photoSearch = PagedPhotoSearch(searchTerm: searchTerm, resultsPerPage: 30)
      .demanded { continuation in
        self.continuation = continuation
      }

    searchTask = Task { [weak self] in

      do {
        for try await batch in photoSearch {
          guard let self else { return }
          Log.view.debug("PhotoSearchViewModel - Received new batch of photos")
          self.isLoading = false

          guard !Task.isCancelled else { break }

          self.photos += batch
        }
      } catch {
        self?.errorMessage = error.localizedDescription
      }
    }

    loadMoreIfNeeded(currentItem: nil)
  }

  func loadMoreIfNeeded(currentItem: Photo?) {
    guard
      !isLoading,                         // Only request more if loading is not in progress
      currentItem?.id == photos.last?.id  // Only request more if we have reached the last item
    else { return }

    Log.view.debug("PhotoSearchViewModel - Reached last item. Loading more...")

    isLoading = true
    continuation?.yield()
  }
}
