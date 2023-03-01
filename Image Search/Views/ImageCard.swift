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
            image.resizable()
        } placeholder: {
            Image(systemName: "photo.artframe")
                .resizable()
                .foregroundColor(.gray.opacity(0.5))
                .padding()
        }
        .aspectRatio(contentMode: .fill)
        .frame(
            minWidth: 0,
            maxWidth: .infinity,
            minHeight: 0,
            maxHeight: .infinity
        )
        .aspectRatio(1, contentMode: .fit)
        .clipShape(RoundedRectangle(cornerRadius: 6))
    }
}

struct ImageCard_Previews: PreviewProvider {
    static var previews: some View {
        ImageCard(photo: .previewData)
            .padding()
    }
}
