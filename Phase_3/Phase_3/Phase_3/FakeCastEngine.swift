//
//  FakeCastEngine.swift
//  Phase_3
//
//  Created by neermita.bhattacharya@wbd.com on 12/08/26.
//

import Foundation
import Combine

class FakeCastEngine: PlaybackEngine {
    private let devicesSubject = CurrentValueSubject<[CastDevice], Never>([])
   
    public var devicesPublisher : AnyPublisher<[CastDevice], Never>{
        devicesSubject.eraseToAnyPublisher()
    }
    private let playbackStateSubject = CurrentValueSubject<PlaybackState, Never>(.paused)
    public var playbackStatePublisher: AnyPublisher<PlaybackState, Never> {
        playbackStateSubject.eraseToAnyPublisher()
    }
    private let nowPlayingSubject = CurrentValueSubject<NowPlayingItem?, Never>(nil)
    
    public var nowPlayingPublisher: AnyPublisher<NowPlayingItem?, Never> {
        nowPlayingSubject.eraseToAnyPublisher()
    }
    
    private var timer : Timer?
    private let possibleDevices = [
        CastDevice(id: "100", name: "Living Room TV", type: .tv),
        CastDevice(id: "102", name: "Bedroom TV", type: .tv),
        CastDevice(id: "103", name: "Kitchen Display", type: .display),
        CastDevice(id: "104", name: "Study Room Projector", type: .display)
    ]
    private var mediaTimer: Timer?
    private var mediaIndex = 0
  
    
    func startDiscovery(){
        timer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true){
            [weak self] _ in
            guard let self = self else{
                return
            }
            
            let shuffle = self.possibleDevices.shuffled()
            let randomCount = Int.random(in: 0...self.possibleDevices.count)
            let foundDevices = Array(shuffle.prefix(randomCount))
            
            self.devicesSubject.send(foundDevices)
        }
    }
    func stopDiscovery() {
            timer?.invalidate()
            timer = nil
            devicesSubject.send([])
        }
    func togglePlayPause(){
        let next : PlaybackState = (playbackStateSubject.value == .playing) ? .paused : .playing
        print("currently: ",next)
        playbackStateSubject.send(next)
    }
    // Called when the user picks a poster
    // Called when the user picks a poster
    func loadMedia(_ item: NowPlayingItem) {
        nowPlayingSubject.send(item)
        var s = remoteStateSubject.value
        s.isPlaying = true                 // single playback truth
        remoteStateSubject.send(s)
    }

    func stopNowPlaying() {
        mediaTimer?.invalidate()
        mediaTimer = nil
    }
    private let dvrWindow: TimeInterval = 1800   // 30-min DVR buffer

    private let remoteStateSubject = CurrentValueSubject<RemoteMediaState, Never>(.vod(duration: 2700))
    public var remoteStatePublisher: AnyPublisher<RemoteMediaState, Never> {
        remoteStateSubject.eraseToAnyPublisher()
    }
    private var progressTimer: Timer?
    
    
    // The heartbeat: advances progress once per second.
    func startRemotePlayback() {
        progressTimer?.invalidate()
        progressTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            var s = self.remoteStateSubject.value

            // Live edge always marches forward, even when paused.
            if s.streamType == .liveDVR {
                s.seekableEnd += 1
                s.seekableStart = max(0, s.seekableEnd - self.dvrWindow)
                s.duration = s.seekableEnd
            }
            // The playhead only moves when playing.
            if s.isPlaying {
                let maxTime = (s.streamType == .vod) ? s.duration : s.seekableEnd
                s.currentTime = min(s.currentTime + 1, maxTime)
            }
            self.remoteStateSubject.send(s)
        }
    }

    func stopRemotePlayback() {
        progressTimer?.invalidate()
        progressTimer = nil
    }

    func toggleRemotePlayPause() {
        var s = remoteStateSubject.value
        s.isPlaying.toggle()
        remoteStateSubject.send(s)
    }

    // Absolute seek — clamped inside the seekable window.
    func seekRemote(to time: TimeInterval) {
        var s = remoteStateSubject.value
        let end = (s.streamType == .vod) ? s.duration : s.seekableEnd
        s.currentTime = min(max(time, s.seekableStart), end)
        remoteStateSubject.send(s)
    }

    func skipRemote(by delta: TimeInterval) {
        seekRemote(to: remoteStateSubject.value.currentTime + delta)
    }

    func goToLive() {
        var s = remoteStateSubject.value
        guard s.streamType == .liveDVR else { return }
        s.currentTime = s.seekableEnd
        remoteStateSubject.send(s)
    }

    func setStreamType(_ type: StreamType) {
        let fresh: RemoteMediaState = (type == .vod)
            ? .vod(duration: 2700)
            : .live(dvrWindow: dvrWindow, startedSecondsAgo: 600)
        remoteStateSubject.send(fresh)
    }
    
}

