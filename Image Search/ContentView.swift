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
        ScrollView {
            LazyVGrid(
                columns: [
                    GridItem(.flexible()),
                    GridItem(.flexible()),
                    GridItem(.flexible())
                ]
            ) {
                ForEach(viewModel.photos) { photo in
                    ImageCard(photo: photo)
                        .onAppear {
                            Log.views.debug("Photo view appear \(photo.id) - \(photo.altText)")
                        }
                }
            }
        }
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
