//
//  URL+.swift
//  Image Search
//
//  Created by Robert Moyer on 2/24/23.
//

import Foundation

extension URL {
    init(_ staticString: StaticString) {
        guard let url = URL(string: "\(staticString)") else {
            fatalError()
        }

        self = url
    }
}
