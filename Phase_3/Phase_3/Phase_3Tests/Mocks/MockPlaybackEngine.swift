//
//  MockPlaybackEngine.swift
//  Phase_3
//
//  Created by neermita.bhattacharya@wbd.com on 25/08/26.
//

import Foundation
import Combine
@testable import Phase_3

final class MockPlaybackEngine: PlaybackEngine {
    // Inputs you can pump in tests
    let nowPlayingSubject  = CurrentValueSubject<NowPlayingItem?, Never>(nil)
    let remoteStateSubject = CurrentValueSubject<RemoteMediaState, Never>(.vod(duration: 120))

    var nowPlayingPublisher: AnyPublisher<NowPlayingItem?, Never> { nowPlayingSubject.eraseToAnyPublisher() }
    var remoteStatePublisher: AnyPublisher<RemoteMediaState, Never> { remoteStateSubject.eraseToAnyPublisher() }

    // Spies — record what the interactor asked the engine to do
    private(set) var loadMediaCalls: [NowPlayingItem] = []
    private(set) var toggleCount = 0
    private(set) var startCount = 0
    private(set) var stopCount = 0
    private(set) var seekCalls: [TimeInterval] = []
    private(set) var skipCalls: [TimeInterval] = []
    private(set) var goToLiveCount = 0
    private(set) var setStreamTypeCalls: [StreamType] = []

    func loadMedia(_ item: NowPlayingItem) {
        loadMediaCalls.append(item)
        nowPlayingSubject.send(item)
    }
    func toggleRemotePlayPause() {
        toggleCount += 1
        var s = remoteStateSubject.value; s.isPlaying.toggle(); remoteStateSubject.send(s)
    }
    func startRemotePlayback() { startCount += 1 }   // no real timer in tests -> deterministic
    func stopRemotePlayback() { stopCount += 1 }
    func seekRemote(to time: TimeInterval) {
        seekCalls.append(time)
        var s = remoteStateSubject.value; s.currentTime = time; remoteStateSubject.send(s)
    }
    func skipRemote(by delta: TimeInterval) {
        skipCalls.append(delta)
        seekRemote(to: remoteStateSubject.value.currentTime + delta)
    }
    func goToLive() {
        goToLiveCount += 1
        var s = remoteStateSubject.value; s.currentTime = s.seekableEnd; remoteStateSubject.send(s)
    }
    func setStreamType(_ type: StreamType) { setStreamTypeCalls.append(type) }
}
