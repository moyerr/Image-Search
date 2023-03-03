//
//  PhotoSearchView.swift
//  Image Search
//
//  Created by Robert Moyer on 3/2/23.
//

import SwiftUI

struct PhotoSearchView: View {
  @StateObject private var viewModel = PhotoSearchViewModel()

  var body: some View {
    NavigationStack {
      Group {
        if viewModel.isLoading, viewModel.photos.isEmpty {
          ProgressView(viewModel.loadingText)
        } else if viewModel.photos.isEmpty {
          Text("No Results")
            .foregroundColor(.secondary)
            .font(.body)
        } else {
          ScrollView {
            Group {
              PhotoGridView(photos: viewModel.photos) { photo in
                Log.view.debug("Photo did appear \(photo.id) - \(photo.altText)")
                viewModel.loadMoreIfNeeded(currentItem: photo)
              }

              if viewModel.isLoading {
                ProgressView(viewModel.loadingText)
              }
            }.padding(8)
          }
        }
      }
      .searchable(text: $viewModel.searchText, prompt: "Search images")
      .navigationTitle("Image Search")
    }
  }
}

struct PhotoListView_Previews: PreviewProvider {
  static var previews: some View {
    PhotoSearchView()
  }
}
