//
//  ImageLoader.swift
//  Image Search
//
//  Created by Robert Moyer on 2/16/23.
//

import UIKit

struct ImageLoader {
    private let downloader = URLSession.shared

    func image(for url: URL) async throws -> UIImage {
        try await downloadImage(from: url)
    }

    private func downloadImage(from url: URL) async throws -> UIImage {
        let (data, _) = try await downloader.data(from: url)
        return UIImage(data: data) ?? UIImage()
    }
}
