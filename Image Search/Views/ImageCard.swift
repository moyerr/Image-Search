//
//  ImageCard.swift
//  Image Search
//
//  Created by Robert Moyer on 2/24/23.
//

import SwiftUI

struct ImageCard: View {
    let photo: Photo

    var body: some View {
        AsyncImage(url: photo.source.medium) { image in
            image.resizable(resizingMode: .stretch)
        } placeholder: {
            Image(systemName: "photo.artframe")
                .resizable()
        }
        .scaledToFill()
        .clipped()

    }
}

struct ImageCard_Previews: PreviewProvider {
    static var previews: some View {
        ImageCard(photo: .previewData)
            .padding()
    }
}
