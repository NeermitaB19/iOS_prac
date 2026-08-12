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
    
    
    private var timer : Timer?
    private let possibleDevices = [
        CastDevice(id: "100", name: "Living Room TV", type: .tv),
        CastDevice(id: "102", name: "Bedroom TV", type: .tv),
        CastDevice(id: "103", name: "Kitchen Display", type: .display),
        CastDevice(id: "104", name: "Kids iPad", type: .display)
    ]
    
    func startDiscovery(){
        timer = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: true){
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
    
}

