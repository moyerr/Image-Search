//
//  Secrets.swift
//  Image Search
//
//  Created by Robert Moyer on 3/2/23.
//

import Foundation

struct Secrets: Codable {
  private enum CodingKeys: String, CodingKey {
    case apiKey = "api-key"
  }

  let apiKey: String
}

@propertyWrapper
struct Secret<Value> {
  let keyPath: KeyPath<Secrets, Value>

  var wrappedValue: Value {
    secrets[keyPath: keyPath]
  }

  init(_ keyPath: KeyPath<Secrets, Value>) {
      self.keyPath = keyPath
  }
}

private let secrets: Secrets = {
  guard
    let url = Bundle.main.url(
      forResource: "Secrets",
      withExtension: "plist"
    ),
    let data = try? Data(contentsOf: url)
  else {
    fatalError("Could not find Secrets.plist file in bundle.")
  }

  guard
    let secrets = try? data.decoded(using: PropertyListDecoder()) as Secrets
  else {
    fatalError("Unable to decode Secrets.plist")
  }

  return secrets
}()
