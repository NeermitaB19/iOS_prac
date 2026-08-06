import Cocoa
import Combine
import Foundation
import SwiftUI
import PlaygroundSupport
PlaygroundPage.current.needsIndefiniteExecution = true

struct CastDevice : Identifiable, Equatable{
    let id : String
    let name : String
    
}

class FakeCastEngine {
    init(){}
    private let devicesSubject = CurrentValueSubject<[CastDevice], Never>([]) // i dont want consumers to be able to insert fake data
    public var devicesPublisher : AnyPublisher<[CastDevice], Never>{
        devicesSubject.eraseToAnyPublisher()
    }
    private var timer: Timer?

    private let possibleDevices = [
            CastDevice(id: "100", name: "Living Room TV"),
            CastDevice(id: "102", name: "Bedroom TV"),
            CastDevice(id: "103", name: "Kitchen Display"),
            CastDevice(id: "104", name: "Kids iPad")
        ]
    
    func startDiscovery(){
        timer = Timer.scheduledTimer(withTimeInterval: 1.5, repeats: true) { [weak self] _ in
            
            guard let self = self else {
                return}
            
            let shuffle = self.possibleDevices.shuffled()
            let randomCount = Int.random(in: 0 ... self.possibleDevices.count)
            let foundDevices = Array(shuffle.prefix(randomCount))
            
            self.devicesSubject.send(foundDevices)
            }
            
        }
    }
    
class Consumer{
    
    
    private var cancellable = Set<AnyCancellable>()
    private let engine: FakeCastEngine
    init(engine : FakeCastEngine){
        self.engine = engine
    }
    
    func startListening(){
        print("Consumer starts listening..")
        engine.devicesPublisher.debounce(for: .seconds(0.5), scheduler : DispatchQueue.main)
            .sink{[weak self] devices in
                guard let self = self else {return}
                print("-------------------------Found \(devices.count) devices-------------------------")
                for device in devices {
                    print("Device: \(device.name), Device ID:  \(device.id)")
                }
                }
            .store(in: &cancellable)
        
    }
    
}
    

var fc = FakeCastEngine()
var consumer = Consumer(engine: fc)
consumer.startListening()
fc.startDiscovery()
