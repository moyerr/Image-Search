//
//  PreviewData.swift
//  Image Search
//
//  Created by Robert Moyer on 2/24/23.
//

import Foundation

extension Photo {
    static let previewData = Photo(
        id: 1087735,
        width: 4256,
        height: 2532,
        url: URL("https://www.pexels.com/photo/silhouette-of-man-standing-on-mountain-cliff-1087735/"),
        photographer: .previewData,
        averageColor: "#6E858B",
        source: .previewData,
        liked: false,
        altText: "Silhouette of Man Standing on Mountain Cliff"
    )
}

extension Photographer {
    static let previewData = Photographer(
        id: 206851,
        name: "Min An",
        url: URL("https://www.pexels.com/@minan1398")
    )
}

extension Photo.Source {
    static let previewData = Photo.Source(
        original: URL("https://images.pexels.com/photos/1087735/pexels-photo-1087735.jpeg"),
        large2x: URL("https://images.pexels.com/photos/1087735/pexels-photo-1087735.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940"),
        large: URL("https://images.pexels.com/photos/1087735/pexels-photo-1087735.jpeg?auto=compress&cs=tinysrgb&h=650&w=940"),
        medium: URL("https://images.pexels.com/photos/1087735/pexels-photo-1087735.jpeg?auto=compress&cs=tinysrgb&h=350"),
        small: URL("https://images.pexels.com/photos/1087735/pexels-photo-1087735.jpeg?auto=compress&cs=tinysrgb&h=130"),
        portrait: URL("https://images.pexels.com/photos/1087735/pexels-photo-1087735.jpeg?auto=compress&cs=tinysrgb&fit=crop&h=1200&w=800"),
        landscape: URL("https://images.pexels.com/photos/1087735/pexels-photo-1087735.jpeg?auto=compress&cs=tinysrgb&fit=crop&h=627&w=1200"),
        tiny: URL("https://images.pexels.com/photos/1087735/pexels-photo-1087735.jpeg?auto=compress&cs=tinysrgb&dpr=1&fit=crop&h=200&w=280")
    )
}
