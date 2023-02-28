//
//  Codable+.swift
//  Image Search
//
//  Created by Robert Moyer on 2/28/23.
//

import Foundation

// MARK: Decoding

extension Data {
    func decoded<T>(
        using decoder: DataDecoder = JSONDecoder()
    ) throws -> T where T: Decodable {
        try decoder.decode(T.self, from: self)
    }
}

// MARK: Encoding

extension Encodable {
    func encoded(
        using encoder: DataEncoder = JSONEncoder()
    ) throws -> Data {
        try encoder.encode(self)
    }
}

// MARK: DataDecoder

protocol DataDecoder {
    func decode<T>(
        _ type: T.Type,
        from data: Data
    ) throws -> T where T : Decodable
}

extension JSONDecoder: DataDecoder {}
extension PropertyListDecoder: DataDecoder {}

// MARK: DataEncoder

protocol DataEncoder {
    func encode<T>(
        _ value: T
    ) throws -> Data where T : Encodable
}

extension JSONEncoder: DataEncoder {}
extension PropertyListEncoder: DataEncoder {}


