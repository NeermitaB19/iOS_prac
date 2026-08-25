//
//  PlayerSanpshotTests.swift
//  Phase_3
//
//  Created by neermita.bhattacharya@wbd.com on 25/08/26.
//

import XCTest
import SwiftUI
import Combine
import SnapshotTesting
@testable import Phase_3

final class PlayerSnapshotTests: XCTestCase {

    // Flip to true ONCE to record baselines, then set back to false and commit them.
    override func setUp() {
        super.setUp()
        // isRecording = true
    }

    func test_miniPlayerBar_playing() {
        let engine = MockPlaybackEngine()
        let interactor = MiniPlayerInteractor(engine: engine)
        interactor.start()
        engine.remoteStateSubject.send(vod(isPlaying: true))
        engine.nowPlayingSubject.send(NowPlayingItem(title: "Dune: Part Two", subtitle: "Movie", artworkURL: nil))
        waitUntilLoaded(interactor.viewStateBox)

        let view = MiniPlayerBar(interactor: interactor)
            .frame(width: 390)
            .background(Color.black)
        assertSnapshot(of: UIHostingController(rootView: view), as: .image(on: .iPhone13))
    }

    func test_expandedPlayer_vod_disconnected() {
        let engine = MockPlaybackEngine()
        let interactor = PlayerInteractor(engine: engine)
        let cast = CastViewModel(engine: FakeCastEngine(), defaults: ephemeralDefaults())
        interactor.start()
        engine.remoteStateSubject.send(RemoteMediaState(streamType: .vod, currentTime: 30, duration: 120,
                                                        isPlaying: true, seekableStart: 0, seekableEnd: 120))
        waitUntilLoaded(interactor.viewStateBox)

        let view = PlayerView(interactor: interactor, castViewModel: cast)
        assertSnapshot(of: UIHostingController(rootView: view), as: .image(on: .iPhone13))
    }

    func test_expandedPlayer_live_disconnected() {
        let engine = MockPlaybackEngine()
        let interactor = PlayerInteractor(engine: engine)
        let cast = CastViewModel(engine: FakeCastEngine(), defaults: ephemeralDefaults())
        interactor.start()
        engine.remoteStateSubject.send(RemoteMediaState(streamType: .liveDVR, currentTime: 570, duration: 600,
                                                        isPlaying: true, seekableStart: 0, seekableEnd: 600))
        waitUntilLoaded(interactor.viewStateBox)

        let view = PlayerView(interactor: interactor, castViewModel: cast)
        assertSnapshot(of: UIHostingController(rootView: view), as: .image(on: .iPhone13))
    }

    // MARK: helpers
    private func vod(isPlaying: Bool) -> RemoteMediaState {
        RemoteMediaState(streamType: .vod, currentTime: 0, duration: 120,
                         isPlaying: isPlaying, seekableStart: 0, seekableEnd: 120)
    }
    private func ephemeralDefaults() -> UserDefaults {
        UserDefaults(suiteName: "snap.\(UUID().uuidString)")!
    }
    private func waitUntilLoaded(_ isLoaded: @autoclosure () -> Bool, timeout: TimeInterval = 1) {
        let deadline = Date().addingTimeInterval(timeout)
        while !isLoaded() && Date() < deadline {
            RunLoop.main.run(until: Date().addingTimeInterval(0.01))
        }
    }
}
