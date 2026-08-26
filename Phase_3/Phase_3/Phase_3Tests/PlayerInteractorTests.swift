//
//  PlayerInteractorTests.swift
//  Phase_3
//
//  Created by neermita.bhattacharya@wbd.com on 25/08/26.
//

import XCTest
import Combine
@testable import Phase_3

final class PlayerInteractorTests: XCTestCase {
    private var engine: MockPlaybackEngine!
    private var sut: PlayerInteractor!
    private var cancellables: Set<AnyCancellable>!

    override func setUp() {
        super.setUp()
        engine = MockPlaybackEngine()
        sut = PlayerInteractor(engine: engine)
        cancellables = []
    }
    override func tearDown() {
        cancellables = nil; sut = nil; engine = nil
        super.tearDown()
    }

    // Subscribe, send a state, return the first matching loaded data.
    @discardableResult
    private func loaded(sending state: RemoteMediaState,
                        where predicate: @escaping (PlayerViewData) -> Bool = { _ in true }) -> PlayerViewData? {
        let exp = expectation(description: "loaded")
        var result: PlayerViewData?
        sut.$viewState
            .sink { if case .loaded(let d) = $0, predicate(d), result == nil { result = d; exp.fulfill() } }
            .store(in: &cancellables)
        sut.start()
        engine.remoteStateSubject.send(state)
        wait(for: [exp], timeout: 1)
        return result
    }

    func test_start_startsEnginePlayback() {
        sut.start()
        XCTAssertEqual(engine.startCount, 1)
    }

    func test_vod_progressAndTimeLabels() {
        let s = RemoteMediaState(streamType: .vod, currentTime: 30, duration: 120,
                                 isPlaying: true, seekableStart: 0, seekableEnd: 120)
        let data = loaded(sending: s) { $0.currentTimeLabel == "00:30" }
        XCTAssertEqual(data?.isLive, false)
        XCTAssertEqual(data?.progress ?? 0, 0.25, accuracy: 0.001)
        XCTAssertEqual(data?.currentTimeLabel, "00:30")
        XCTAssertEqual(data?.trailingLabel, "02:00")
    }

    func test_live_atEdge_showsLIVE() {
        let s = RemoteMediaState(streamType: .liveDVR, currentTime: 600, duration: 600,
                                 isPlaying: true, seekableStart: 0, seekableEnd: 600)
        let data = loaded(sending: s) { $0.isAtLiveEdge }
        XCTAssertEqual(data?.isLive, true)
        XCTAssertEqual(data?.trailingLabel, "● LIVE")
    }

    func test_live_behindEdge_showsNegativeOffset() {
        let s = RemoteMediaState(streamType: .liveDVR, currentTime: 570, duration: 600,
                                 isPlaying: true, seekableStart: 0, seekableEnd: 600)
        let data = loaded(sending: s) { $0.isLive && !$0.isAtLiveEdge }
        XCTAssertEqual(data?.isLive, true)
        XCTAssertEqual(data?.trailingLabel, "-00:30")
    }

    func test_seekToFraction_computesAbsoluteTime_vod() {
        let s = RemoteMediaState(streamType: .vod, currentTime: 0, duration: 200,
                                 isPlaying: true, seekableStart: 0, seekableEnd: 200)
        loaded(sending: s)                     // ensures `latest` is set
        sut.seek(toFraction: 0.5)
        XCTAssertEqual(engine.seekCalls.last ?? -1, 100, accuracy: 0.001)
    }

    func test_skip_delegatesWithCorrectDeltas() {
        sut.skipForward();  XCTAssertEqual(engine.skipCalls.last, 10)
        sut.skipBackward(); XCTAssertEqual(engine.skipCalls.last, -10)
    }

    func test_togglePlayPause_delegates() {
        sut.togglePlayPause()
        XCTAssertEqual(engine.toggleCount, 1)
    }

    func test_toggleStreamType_fromVOD_requestsLive() {
        loaded(sending: .vod(duration: 120))   // latest is VOD
        sut.toggleStreamType()
        XCTAssertEqual(engine.setStreamTypeCalls.last, .liveDVR)
    }

    func test_stop_stopsEngine_andAllowsRestart() {
        sut.start()
        sut.stop()
        XCTAssertEqual(engine.stopCount, 1)
        sut.start()                            // guard cancellables.isEmpty must allow this
        XCTAssertEqual(engine.startCount, 2)
    }
}
