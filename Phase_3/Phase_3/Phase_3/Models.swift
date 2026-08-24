//
//  Models.swift
//  Phase_3
//
//  Created by neermita.bhattacharya@wbd.com on 12/08/26.
//

import Foundation
import Combine
 
enum CastDeviceType : String , Codable{
    case tv, speaker, display, group
}

struct CastDevice : Identifiable, Equatable, Codable{
    let id : String
    let name : String
    var type : CastDeviceType = .tv
}

// equatble works by default for enums and structs; for classes manually implement
enum NetworkError : Error, Equatable {
    case connectionFailed
    case invalidResponse
    case authenticationFailed
}

enum TransitionError : Error{
    case illegalTransition
}

enum ConnectionState : Equatable{
    case disconnected
    case discovering
    case connecting(CastDevice)
    case connected(CastDevice)
    case reconnecting(CastDevice)
    case failed(NetworkError)
}

extension ConnectionState {
    func validateTransition(to next : ConnectionState) throws {
        switch (self, next) {
        case (.disconnected, .discovering): return
        case (.discovering, .connecting(_)): return
        case (.connecting(_), .connected(_)): return
        case (.connecting(_), .failed(_)): return
        case (.connecting(_), .disconnected): return
        case (.reconnecting(_), .disconnected): return
        case (.reconnecting(_), .connected(_)): return
        case (.connected(_), .disconnected): return
        case (.connected(_), .reconnecting(_)): return
        case (.failed(_), .discovering): return
        default:
            throw TransitionError.illegalTransition
        }
    }
}

enum PlaybackState : Equatable{
    case playing
    case paused
}

struct NowPlayingItem: Equatable {
    let title: String
    let subtitle: String
    let artworkURL: URL?   // real poster image
}

enum StreamType: Equatable {
    case vod
    case liveDVR
}

struct RemoteMediaState: Equatable {
    var streamType: StreamType
    var currentTime: TimeInterval   // where the playhead is
    var duration: TimeInterval      // VOD: total length; live: current live edge
    var isPlaying: Bool
    var seekableStart: TimeInterval // start of what you can scrub to
    var seekableEnd: TimeInterval   // end of scrubbable range (= live edge for live)
}

extension RemoteMediaState {
    static func vod(duration: TimeInterval) -> RemoteMediaState {
        RemoteMediaState(streamType: .vod, currentTime: 0, duration: duration,
                         isPlaying: true, seekableStart: 0, seekableEnd: duration)
    }
    static func live(dvrWindow: TimeInterval, startedSecondsAgo: TimeInterval) -> RemoteMediaState {
        RemoteMediaState(streamType: .liveDVR, currentTime: startedSecondsAgo,
                         duration: startedSecondsAgo, isPlaying: true,
                         seekableStart: max(0, startedSecondsAgo - dvrWindow),
                         seekableEnd: startedSecondsAgo)
    }
}
