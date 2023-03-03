//
//  PhotoGridView.swift
//  Image Search
//
//  Created by Robert Moyer on 3/2/23.
//

import SwiftUI

struct PhotoGridView: View {
  let photos: [Photo]
  let photoDidAppear: (Photo) -> Void
  
  var body: some View {
    LazyVGrid(
      columns: [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
      ]
    ) {
      ForEach(photos) { photo in
        ImageCard(photo: photo)
          .onAppear { photoDidAppear(photo) }
      }
    }
  }
}

//struct PhotoGridView_Previews: PreviewProvider {
//  static var previews: some View {
//    PhotoGridView()
//  }
//}
