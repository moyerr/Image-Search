//
//  ContentView.swift
//  Image Search
//
//  Created by Robert Moyer on 2/16/23.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = PhotoListViewModel()

    var body: some View {
        List(viewModel.photos) { photo in
            ImageCard(photo: photo)
        }
        .listStyle(.plain)
        .onAppear {
            viewModel.searchPhotos("race cars")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
