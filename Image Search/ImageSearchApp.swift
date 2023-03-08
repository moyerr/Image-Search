//
//  ImageSearchApp.swift
//  Image Search
//
//  Created by Robert Moyer on 2/16/23.
//

import SwiftUI

@main
struct ImageSearchApp: App {
  var body: some Scene {
    WindowGroup {
      NavigationStack {
        PhotoSearchView()
      }
    }
  }
}
