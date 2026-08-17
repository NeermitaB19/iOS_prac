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


class DeviceManager{
    private let statesub=CurrentValueSubject<ConnectionState, Never>(ConnectionState.disconnected)
    var statePublisher: AnyPublisher<ConnectionState, Never> {
            statesub.eraseToAnyPublisher()
        }
    var currentState: ConnectionState{
        statesub.value
    }
    var list: [CastDevice] = []
    init(){}
    
    func transition(to next: ConnectionState) throws{
        guard validTransition(from: currentState, to: next)else{
            statesub.send(.failed(.illegalTransition))
                        throw NetworkError.illegalTransition
        }
        statesub.send(next)
        print("transitioned to \(next)")
    }
    
    func addDevice(device: CastDevice){
        if !list.contains(where: {
            existsdevice in existsdevice.id == device.id
        }){
            list.append(device)
        }
    }
    func findDevice(id: Int)-> CastDevice?{
        return list.first(where:{$0.id==id})
    }
    func filter(type: CastDeviceType)-> [CastDevice]{
        return list.filter({
            d in d.type == type
        })
    }
    
    func discover() async throws{
        try transition(to: .discovering)
        try await Task.sleep(nanoseconds:1_000_000_000)
        addDevice(device: CastDevice(id: 1, name: "Living Room TV", type: .tv))
        addDevice(device: CastDevice(id: 2, name: "Meeting Projector", type: .projector))
                
        print("Discovery complete. Found \(list.count) devices.")
        
    }
    func connect(to device: CastDevice) async throws {
            try transition(to: .connecting(device))
            try await Task.sleep(nanoseconds: 2_000_000_000)
            
            try transition(to: .connected(device))
        }
    
}
//dont want other codes to do dm.statesub.send()


let done = DispatchSemaphore(value: 0)
var manager = DeviceManager()

Task {
    do {
        print("Starting discovery...........")
        try await manager.discover()
        if let foundDevice = manager.findDevice(id: 1) {
            print("Device found: \(foundDevice.name). Attempting connection..........")
            try await manager.connect(to: foundDevice)
            print("Successfully connected to \(foundDevice.name)!!!!!")
        } else {
            print("Device with ID 1 not found!")
        }
    } catch {
        print("Operation failed with error: \(error)")
    }
    done.signal()
}


