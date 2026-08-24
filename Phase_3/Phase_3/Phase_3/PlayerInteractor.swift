//
//  PlayerInteractor.swift
//  Phase_3
//
//  Created by neermita.bhattacharya@wbd.com on 24/08/26.
//

import Foundation
import Combine

struct PlayerViewData: Equatable {
    let isLive: Bool
    let isPlaying: Bool
    let progress: Double          // 0...1 for the scrubber
    let currentTimeLabel: String
    let trailingLabel: String     // VOD: total time; live: "LIVE" or "-mm:ss" behind
    let isAtLiveEdge: Bool
    let artworkURL: URL?
}

final class PlayerInteractor: ObservableObject {
    @Published private(set) var viewState: ViewState<PlayerViewData> = .idle

    private let engine: FakeCastEngine
    private var cancellables = Set<AnyCancellable>()
    private var latest: RemoteMediaState?   // kept so seek math has the raw numbers

    init(engine: FakeCastEngine) {
        self.engine = engine
    }

    func start() {
        guard cancellables.isEmpty else { return }
        engine.startRemotePlayback()
        Publishers.CombineLatest(engine.remoteStatePublisher, engine.nowPlayingPublisher)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state, nowPlaying in
                guard let self = self else { return }
                self.latest = state
                self.viewState = .loaded(self.makeViewData(state, artworkURL: nowPlaying?.artworkURL))
            }
            .store(in: &cancellables)
    }
    func stop() {
        engine.stopRemotePlayback()
        cancellables.removeAll()
    }

    // MARK: Actions (view forwards intent; interactor does the math)

    func togglePlayPause() { engine.toggleRemotePlayPause() }
    func skipForward()     { engine.skipRemote(by: 10) }
    func skipBackward()    { engine.skipRemote(by: -10) }
    func goToLive()        { engine.goToLive() }

    func toggleStreamType() {
        guard let s = latest else { return }
        engine.setStreamType(s.streamType == .vod ? .liveDVR : .vod)
    }

    // Scrubber hands us 0...1; we turn it into an absolute time.  (seek math)
    func seek(toFraction f: Double) {
        guard let s = latest else { return }
        let start = s.seekableStart
        let end   = (s.streamType == .vod) ? s.duration : s.seekableEnd
        engine.seekRemote(to: start + f * (end - start))
    }

    // MARK: Mapping raw state -> view-ready data

    private func makeViewData(_ s: RemoteMediaState, artworkURL: URL?) -> PlayerViewData {
        let start  = s.seekableStart
        let end    = (s.streamType == .vod) ? s.duration : s.seekableEnd
        let length = max(end - start, 1)                       // avoid /0
        let progress = (s.currentTime - start) / length        // progress math

        let behindLive = s.seekableEnd - s.currentTime
        let atLive = s.streamType == .liveDVR && behindLive < 2

        let trailing: String
        if s.streamType == .vod {
            trailing = format(s.duration)
        } else {
            trailing = atLive ? "● LIVE" : "-\(format(behindLive))"
        }

        return PlayerViewData(
            isLive: s.streamType == .liveDVR,
            isPlaying: s.isPlaying,
            progress: min(max(progress, 0), 1),
            currentTimeLabel: format(s.currentTime - start),
            trailingLabel: trailing,
            isAtLiveEdge: atLive,
            artworkURL: artworkURL
        )
    }

    // seconds -> mm:ss or h:mm:ss  (time formatting)
    private func format(_ t: TimeInterval) -> String {
        let total = Int(max(t, 0))
        let h = total / 3600, m = (total % 3600) / 60, sec = total % 60
        return h > 0 ? String(format: "%d:%02d:%02d", h, m, sec)
                     : String(format: "%02d:%02d", m, sec)
    }
}
