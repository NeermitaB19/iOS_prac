import Foundation
import Combine

struct CastDevice: Identifiable, Equatable {
    let id : Int
    let name : String
    let type : CastDeviceType
}
enum NetworkError: Error {
    case noInternetConnection
    case timedOut
    case invalidResponse
    case illegalTransition
}
enum ConnectionState: Equatable {
    case disconnected
    case discovering
    case connecting(CastDevice)
    case connected(CastDevice)
    case reconnecting(CastDevice)
    case failed(NetworkError)
}
enum ConnectionEvent: Equatable {
    case started(CastDevice)
    case progress(CastDevice, Double)
    case completed(CastDevice)
    case failed(CastDevice, NetworkError)
}
enum CastDeviceType{
    case tv
    case projector
    case speaker
    case display
}

func validTransition(from: ConnectionState, to: ConnectionState) -> Bool {
    switch (from, to) {
    case (.disconnected, .discovering):
        return true
    case (.discovering, .connecting(_)):
        return true
    case (.discovering, .disconnected):
        return true
    case (.connecting(_), .connected(_)):
        return true
    case (.connecting(_), .failed(_)):
        return true
    case (.connecting(_), .disconnected):
        return true
    case (.connected(_), .reconnecting(_)):
        return true
    case (.connected(_), .disconnected):
        return true
    case (.reconnecting(_), .connected(_)):
        return true
    case (.reconnecting(_), .disconnected):
        return true
    case (.failed(_), .discovering):
        return true
    default:
        return false
    }
}

func canTransition(from: ConnectionState, to: ConnectionState) -> Bool {
    return validTransition(from: from, to: to)
}

class ConnectionEngine {
    private let eventSubject = PassthroughSubject<ConnectionEvent, Never>()
    var eventPublisher: AnyPublisher<ConnectionEvent, Never> {
        eventSubject.eraseToAnyPublisher()
    }
    

    func connect(to device: CastDevice) async throws {
        eventSubject.send(.started(device))
        eventSubject.send(.progress(device, 0.3))
        
        try await withThrowingTaskGroup(of: Void.self) { group in
        
            group.addTask {
                try await Task.sleep(nanoseconds: 2_000_000_000)
            }
         
            group.addTask {
                try await Task.sleep(nanoseconds: 5_000_000_000)
                throw NetworkError.timedOut
            }
            
            try await group.next()
            group.cancelAll()
        }
        
        eventSubject.send(.progress(device, 0.9))
        try await Task.sleep(nanoseconds: 500_000_000)
        
        eventSubject.send(.completed(device))
    }
}
class DeviceManager{
    private let statesub=CurrentValueSubject<ConnectionState, Never>(ConnectionState.disconnected)
    nonisolated var statePublisher: AnyPublisher<ConnectionState, Never> {
            statesub.eraseToAnyPublisher()
        }
    private let connectionEngine = ConnectionEngine()
    
    var list: [CastDevice] = []
    init(){}
    
    private func transition(to next: ConnectionState) throws {
            let current = statesub.value
            guard validTransition(from: current, to: next) else {
                statesub.send(.failed(.illegalTransition))
                throw NetworkError.illegalTransition
            }
            statesub.send(next)
        }
    
    
    func discover() async throws {
            try transition(to: .discovering)
            try await Task.sleep(nanoseconds: 1_000_000_000)
            
            list = [
                CastDevice(id: 1, name: "Living Room TV", type: .tv),
                CastDevice(id: 2, name: "Meeting Projector", type: .projector),
                CastDevice(id:3, name: "Study TV", type:.tv)
            ]
        }
    
    func addDevice(device: CastDevice){
        if !list.contains(where: {
            existsdevice in existsdevice.id == device.id
        }){
            list.append(device)
        }
    }
    func getAvailableDevices() async throws -> [CastDevice] {
        print(list)
            return list
        }
    
    func findDevice(id: Int)-> CastDevice?{
        return list.first(where:{$0.id==id})
    }
    func filter(type: CastDeviceType)-> [CastDevice]{
        return list.filter({
            d in d.type == type
        })
    }
    
    
    func connect(to device: CastDevice) async throws {
            try transition(to: .connecting(device))
        
            try await Task.sleep(nanoseconds: 2_000_000_000)
            
            try transition(to: .connected(device))
        }
    func connectBatch(to devices: [CastDevice]) async{
        await withTaskGroup(of: Void.self){
            group in
            for d in devices{
                group.addTask{
                    do{
                        try await self.connect(to:d)
                    }
                    catch{
                        print(error)
                    }
                }
            }
        }
    }
}
//dont want other codes to do dm.statesub.send()

let done = DispatchSemaphore(value: 0)
var manager = DeviceManager()

Task {
    do {
        print("Starting discovery...........")
        try await manager.discover()
        let devices = try await manager.getAvailableDevices()
        try await manager.connect(to: devices[Int.random(in: 1..<devices.count)])
        manager.statePublisher.sink{
            state in print("connection state: \(state)")
        }
    } catch {
        print("Operation failed with error: \(error)")
    }
    done.signal()
}


