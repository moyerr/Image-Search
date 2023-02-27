//
//  PhotoListViewModel.swift
//  Image Search
//
//  Created by Robert Moyer on 2/24/23.
//

import Foundation

@MainActor
final class PhotoListViewModel: ObservableObject {
    @Published var photos: [Photo] = []

    private var client = PhotoClient()

    func searchPhotos(_ searchTerm: String) {
        Task {
            let stream = client.search(searchTerm)
                .map(\.photos)

            for try await photoBatch in stream {
                photos += photoBatch
            }
        }
    }
}
