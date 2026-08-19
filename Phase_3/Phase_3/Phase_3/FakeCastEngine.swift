//
//  FakeCastEngine.swift
//  Phase_3
//
//  Created by neermita.bhattacharya@wbd.com on 12/08/26.
//

import Foundation
import Combine

class FakeCastEngine  {
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
    func loadMedia(_ item: NowPlayingItem) {
        nowPlayingSubject.send(item)
        playbackStateSubject.send(.playing)   // auto-start playing on selection
    }

    func stopNowPlaying() {
        mediaTimer?.invalidate()
        mediaTimer = nil
    }
    
}

