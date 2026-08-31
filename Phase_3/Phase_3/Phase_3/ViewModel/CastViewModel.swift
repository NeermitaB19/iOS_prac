import Foundation
import Combine

class CastViewModel: ObservableObject {
    @Published private(set) var state: ConnectionState = .disconnected
    @Published private(set) var availableDevices: [CastDevice] = []
    @Published var isPickerPresented = false
    private var reconnectWork: DispatchWorkItem?
    
    private let defaults : UserDefaults //standard is a shared global state
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
    
    init(engine: FakeCastEngine, defaults: UserDefaults = .standard) {
        self.engine = engine
        self.defaults = defaults
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
            guard let self = self else { return }
            self.transition(to: .connected(device))
            self.persist(device)
            self.observeConnectionHealth()
        }
    }

    private func observeConnectionHealth() {
        engine.connectionEvents
            .receive(on: DispatchQueue.main)
            .sink { [weak self] event in
                if case .lost = event { self?.handleDeviceLost() }
            }
            .store(in: &cancellables)
    }

    private func handleDeviceLost() {
        guard case .connected(let device) = state else { return }
        transition(to: .reconnecting(device))              // show "Reconnecting…"

        let work = DispatchWorkItem { [weak self] in
            guard let self = self, case .reconnecting = self.state else { return }
            // Give up: drop the session and reopen the picker.
            self.transition(to: .disconnected)
            self.persist(nil)
            self.presentPicker()
        }
        reconnectWork = work
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0, execute: work)
    }

    func presentPicker() {
        switch state {
        case .disconnected, .failed: startDiscovering()
        default: break
        }
        isPickerPresented = true
    }

    // For demoing the unhappy path from the UI.
    func debugSimulateDeviceLost() {
        engine.simulateDeviceLost()
    }
    func disconnect() {
        reconnectWork?.cancel()
        reconnectWork = nil
        transition(to: .disconnected)
        persist(nil)
    }
//    private func handleReconnectFailed() {
//        guard case .reconnecting = state else { return }
//        transition(to: .disconnected)   // triggers PlayerView's onChange -> dismiss the cover
//        persist(nil)
//        // Let the full-screen player finish dismissing before presenting the picker,
//        // otherwise UIKit complains about presenting while a presentation is in progress.
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) { [weak self] in
//            self?.presentPicker()
//        }
//    }
}
