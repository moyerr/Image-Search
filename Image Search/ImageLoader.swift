//
//  ImageLoader.swift
//  Image Search
//
//  Created by Robert Moyer on 2/16/23.
//

import UIKit
import OSLog

let log = Logger(subsystem: "demo-app", category: "PhotoClient")

struct PhotoClient {
    private let session = URLSession.shared
    private let decoder = JSONDecoder()

    func search(_ searchTerm: String) -> AsyncStream<Page> {
        var currentPage: Page?

        return AsyncStream {
            log.debug("Unfolding stream")

            do {
                if currentPage != nil {
                    if let nextPageUrl = currentPage?.nextPage {
                        log.debug("\tFetching next page")
                        currentPage = try await page(for: nextPageUrl)
                        return currentPage
                    } else {
                        log.debug("\tNo more pages")
                        return nil
                    }
                } else {
                    log.debug("\tInitial fetch")
                    currentPage = try await searchPhotos(searchTerm)
                    return currentPage
                }
            } catch {
                log.error("\(error.localizedDescription, privacy: .public)")
                return nil
            }
        }
    }

    func searchPhotos(_ searchTerm: String) async throws -> Page {
        let encodedTerm = searchTerm.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let url = URL(string: "https://api.pexels.com/v1/search?query=\(encodedTerm)")!
        return try await page(for: url)
    }

    func page(for url: URL) async throws -> Page {
        var request = URLRequest(url: url)

        request.setValue(
            "kV1T51p7Nfud9vdnLhogcGFBOYpb8HMWdCtRjVbDmztRL4tBDMbzhNip",
            forHTTPHeaderField: "Authorization"
        )

        let (data, _) = try await session.data(for: request)

        return try decoder.decode(Page.self, from: data)
    }
}
