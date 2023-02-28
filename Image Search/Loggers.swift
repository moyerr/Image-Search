//
//  Loggers.swift
//  Image Search
//
//  Created by Robert Moyer on 2/28/23.
//

import OSLog

enum Log {
    private static let subsystem = "com.rojomo.testprojects.image-search"

    static let network = Logger(subsystem: subsystem, category: "Networking")
    static let app = Logger(subsystem: subsystem, category: "App Lifecycle")
    static let views = Logger(subsystem: subsystem, category: "View Layer")
    static let stream = Logger(subsystem: subsystem, category: "AsyncStream")
}
