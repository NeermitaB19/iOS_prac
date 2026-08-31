//
//  PlaybackEngine.swift
//  Phase_3
//
//  Created by neermita.bhattacharya@wbd.com on 25/08/26.
//

import Foundation
import Combine

protocol PlaybackEngine: AnyObject {
    var nowPlayingPublisher: AnyPublisher<NowPlayingItem?, Never> { get }
    var remoteStatePublisher: AnyPublisher<RemoteMediaState, Never> { get }

    func loadMedia(_ item: NowPlayingItem)
    func toggleRemotePlayPause()
    func startRemotePlayback()
    func stopRemotePlayback()
    func seekRemote(to time: TimeInterval)
    func skipRemote(by delta: TimeInterval)
    func goToLive()
    func setStreamType(_ type: StreamType)
}
