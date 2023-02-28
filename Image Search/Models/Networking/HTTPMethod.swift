//
//  HTTPMethod.swift
//  Image Search
//
//  Created by Robert Moyer on 2/28/23.
//

import Foundation

enum HTTPMethod {
    case get([URLQueryItem] = [])
    case put(Data?)
    case post(Data?)
    case delete([URLQueryItem] = [])

    var name: String {
        switch self {
        case .get:      return "GET"
        case .put:      return "PUT"
        case .post:     return "POST"
        case .delete:   return "DELETE"
        }
    }
}

extension HTTPMethod {
    static var get: HTTPMethod { .get([]) }
    static var put: HTTPMethod { .put(nil) }
    static var post: HTTPMethod { .post(nil) }
    static var delete: HTTPMethod { .delete([])}
}
