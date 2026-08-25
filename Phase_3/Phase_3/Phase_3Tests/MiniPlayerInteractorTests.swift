//
//  MiniPlayeInteractorTests.swift
//  Phase_3
//
//  Created by neermita.bhattacharya@wbd.com on 25/08/26.
//

import XCTest
import Combine
@testable import Phase_3

final class MiniPlayerInteractorTests: XCTestCase {
    private var engine: MockPlaybackEngine!
    private var sut: MiniPlayerInteractor!
    private var cancellables: Set<AnyCancellable>!

    override func setUp() {
        super.setUp()
        engine = MockPlaybackEngine()
        sut = MiniPlayerInteractor(engine: engine)
        cancellables = []
    }
    override func tearDown() {          // proper teardown -> no leakage between tests
        cancellables = nil
        sut = nil
        engine = nil
        super.tearDown()
    }

    func test_start_withNoMedia_staysIdle() {
        sut.start()
        guard case .idle = sut.viewState else { return XCTFail("expected .idle") }
    }

    func test_whenMediaSet_showsLoadedWithTitleAndPlaying() {
        let exp = expectation(description: "loaded")
        var data: MiniPlayerViewData?
        sut.$viewState
            .sink { if case .loaded(let d) = $0 { data = d; exp.fulfill() } }
            .store(in: &cancellables)

        sut.start()
        engine.remoteStateSubject.send(vod(isPlaying: true))
        engine.nowPlayingSubject.send(NowPlayingItem(title: "Dune", subtitle: "Movie", artworkURL: nil))

        wait(for: [exp], timeout: 1)
        XCTAssertEqual(data?.title, "Dune")
        XCTAssertEqual(data?.subtitle, "Movie")
        XCTAssertEqual(data?.isPlaying, true)
    }

    func test_isPlaying_tracksRemoteState_whenPaused() {
        let exp = expectation(description: "paused")
        sut.$viewState
            .sink { if case .loaded(let d) = $0, d.isPlaying == false { exp.fulfill() } }
            .store(in: &cancellables)

        sut.start()
        engine.nowPlayingSubject.send(NowPlayingItem(title: "X", subtitle: "Y", artworkURL: nil))
        engine.remoteStateSubject.send(vod(isPlaying: false))
        wait(for: [exp], timeout: 1)
    }

    func test_play_mapsMediaAndCallsLoadMedia() {
        let media = MediaItem(id: 1, title: "Batman", name: nil,
                              posterPath: "/p.jpg", backdropPath: nil,
                              overview: nil, mediaType: "movie")
        sut.play(media)
        XCTAssertEqual(engine.loadMediaCalls.count, 1)
        XCTAssertEqual(engine.loadMediaCalls.first?.title, "Batman")
        XCTAssertEqual(engine.loadMediaCalls.first?.subtitle, "Movie")
        XCTAssertEqual(engine.loadMediaCalls.first?.artworkURL, media.posterURL)
    }

    func test_togglePlayPause_delegatesToEngine() {
        sut.togglePlayPause()
        XCTAssertEqual(engine.toggleCount, 1)
    }

    private func vod(isPlaying: Bool) -> RemoteMediaState {
        RemoteMediaState(streamType: .vod, currentTime: 0, duration: 120,
                         isPlaying: isPlaying, seekableStart: 0, seekableEnd: 120)
    }
}
