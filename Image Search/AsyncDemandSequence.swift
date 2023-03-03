//
//  AsyncDemandSequence.swift
//  Image Search
//
//  Created by Robert Moyer on 3/2/23.
//

struct AsyncDemandSequence<Base: AsyncSequence>: AsyncSequence {
    typealias Element = Base.Element
    typealias Continuation = AsyncStream<Void>.Continuation

    struct AsyncIterator: AsyncIteratorProtocol {
        private var demandIterator: AsyncStream<Void>.AsyncIterator
        private var baseIterator: Base.AsyncIterator

        fileprivate init(
            demandIterator: AsyncStream<Void>.AsyncIterator,
            baseIterator: Base.AsyncIterator
        ) {
            self.demandIterator = demandIterator
            self.baseIterator = baseIterator
        }

        mutating func next() async throws -> Base.AsyncIterator.Element? {
            Log.sequence.debug("AsyncDemandSequence - begin iteration. Awaiting demand...")
            await demandIterator.next()
            Log.sequence.debug("AsyncDemandSequence - Demand received! Continuing...")
            return try await baseIterator.next()
        }
    }

    private let demandStream: AsyncStream<Void>
    private let base: Base

    init(_ base: Base, _ build: (Continuation) -> Void) {
        self.demandStream = AsyncStream { build($0) }
        self.base = base
    }

    func makeAsyncIterator() -> AsyncIterator {
        AsyncIterator(
            demandIterator: demandStream.makeAsyncIterator(),
            baseIterator: base.makeAsyncIterator()
        )
    }
}

extension AsyncSequence {
    func demanded(
        by continuation: (AsyncDemandSequence.Continuation) -> Void
    ) -> AsyncDemandSequence<Self> {
        .init(self, continuation)
    }
}
