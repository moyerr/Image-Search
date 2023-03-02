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
            PhotoListView()
                .searchable(text: $viewModel.searchText, prompt: "Search photos")
                .navigationTitle("Search")
        }
    }
}

@MainActor
final class PhotoSearchViewModel: ObservableObject {
    @Published var searchText = ""

}

struct PhotoSearchView_Previews: PreviewProvider {
    static var previews: some View {
        PhotoSearchView()
    }
}
