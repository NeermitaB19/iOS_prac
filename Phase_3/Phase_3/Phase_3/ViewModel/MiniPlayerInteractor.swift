//
//  MiniPlayerInteractor.swift
//  Phase_3
//
//  Created by neermita.bhattacharya@wbd.com on 19/08/26.
//

import Foundation
import Combine

struct MiniPlayerViewData: Equatable {
    let title: String
    let subtitle: String
    let artworkURL: URL?
    let isPlaying: Bool
}

class MiniPlayerInteractor: ObservableObject {
    // only code inside this viewmodel can change it, no view can
    @Published private(set) var viewState: ViewState<MiniPlayerViewData> = .idle

    private let engine: PlaybackEngine
    private var cancellables = Set<AnyCancellable>()
    private let defaults: UserDefaults
    private let nowPlayingKey = "nowPlayingItem"

    var viewStateBox: Bool { if case .loaded = viewState { return true }; return false }
    
    init(engine: PlaybackEngine, defaults: UserDefaults = .standard) {
        self.engine = engine
        self.defaults = defaults
    }

    func start() {
        // Re-hydrate the last now-playing item so the mini bar reappears after a relaunch.
        if let data = defaults.data(forKey: nowPlayingKey),
           let item = try? JSONDecoder().decode(NowPlayingItem.self, from: data) {
            engine.loadMedia(item)
        }
        Publishers.CombineLatest(engine.nowPlayingPublisher,
                                 engine.remoteStatePublisher)      // <-- shared truth
            .receive(on: DispatchQueue.main)
            .map { item, remote -> ViewState<MiniPlayerViewData> in
                guard let item = item else { return .idle }
                return .loaded(MiniPlayerViewData(
                    title: item.title,
                    subtitle: item.subtitle,
                    artworkURL: item.artworkURL,
                    isPlaying: remote.isPlaying                    // <-- from remoteState
                ))
            }
            .sink { [weak self] state in self?.viewState = state }
            .store(in: &cancellables)
    }

    // The user tapped a poster -> turn the catalog item into a now-playing item.
    func play(_ media: MediaItem) {
        let item = NowPlayingItem(
            title: media.displayName,
            subtitle: (media.mediaType ?? "Video").capitalized,
            artworkURL: media.posterURL
        )
        engine.loadMedia(item)
        if let data = try? JSONEncoder().encode(item) {
            defaults.set(data, forKey: nowPlayingKey)   // remember across relaunch
        }
        print("tapped on poster")
    }

    func togglePlayPause() {
        engine.toggleRemotePlayPause()     // same command the expanded player uses
    }
}
