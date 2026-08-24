import Foundation
import Combine

class CastViewModel: ObservableObject {
    @Published private(set) var state: ConnectionState = .disconnected
    @Published private(set) var availableDevices: [CastDevice] = []
    
    private let defaults = UserDefaults.standard
    private let connectedDeviceKey = "connectedDevice"
    
    private func persist(_ device: CastDevice?) {
        if let device, let data = try? JSONEncoder().encode(device) {
            defaults.set(data, forKey: connectedDeviceKey)
        } else {
            defaults.removeObject(forKey: connectedDeviceKey)   // cleared on disconnect
        }
    }
    
    private func restoreSession() {
        guard let data = defaults.data(forKey: connectedDeviceKey),
              let device = try? JSONDecoder().decode(CastDevice.self, from: data)
        else { return }
        state = .connected(device)   // set directly; we're restoring, not transitioning
    }
    
    private let engine: FakeCastEngine
    private var cancellables = Set<AnyCancellable>()
    
    init(engine: FakeCastEngine) {
        self.engine = engine
        restoreSession()
    }
    
  
    
    private func transition(to next: ConnectionState) {
        do {
            try state.validateTransition(to: next)
            self.state = next
            print("transitioned successfully to \(next)!!!")
        } catch {
            print("blocked transition from \(state) to \(next)")
        }
    }
    
    func startDiscovering() {
        transition(to: .discovering)
        engine.startDiscovery()
        
        engine.devicesPublisher
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .removeDuplicates()
            .sink { [weak self] devices in
                self?.availableDevices = devices
            }
            .store(in: &cancellables)
    }
    
    func stopDiscovering() {
        transition(to: .disconnected)
        engine.stopDiscovery()
        cancellables.removeAll()
        availableDevices = []
    }
    
    func connect(to device: CastDevice) {
        transition(to: .connecting(device))
        engine.stopDiscovery()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { [weak self] in
            self?.transition(to: .connected(device))
            self?.persist(device)
        }
    }
    
    func disconnect() {
        transition(to: .disconnected)
        persist(nil)
    }
}
