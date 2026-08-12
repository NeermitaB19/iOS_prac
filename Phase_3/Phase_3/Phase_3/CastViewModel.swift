//
//  CastViewModel.swift
//  Phase_3
//
//  Created by neermita.bhattacharya@wbd.com on 12/08/26.
//

import Foundation
import Combine

class CastViewModel : ObservableObject {
    // MARK: Published UI State
    @Published private(set) var state: ConnectionState = ConnectionState.disconnected
    @Published  private(set) var availableDevices: [CastDevice] = []
    
    //MARK: Dependencies
    private let engine: FakeCastEngine
    private var cancellables = Set<AnyCancellable>()
    
    init(engine : FakeCastEngine ){
       
        self.engine = engine
    }
    // MARK: - The Gatekeeper
    private func transition(to next: ConnectionState){
        do {
            try state.validateTransition(to: next)
            self.state = next
            print("transitioned succesfully to \(next)")
        }catch {
            print("blocked transition from \(state) to \(next)")
        }
    }
    
        //MARK: Intents
    func  startDiscovering(){
        transition(to: ConnectionState.discovering)
        engine.startDiscovery()
        
        engine.devicesPublisher
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .removeDuplicates()
            .sink{ [weak self] devices in
                self?.availableDevices = devices
            }
                .store(in: &cancellables)
        
    }
    func stopDiscovering() {
            // If we are connected, we shouldn't wipe the state to discovering.
            // The validator will safely block this if the sheet is dismissed while connected!
            transition(to: .disconnected)
            engine.stopDiscovery()
            cancellables.removeAll()
            availableDevices = []
        }
    
    
    
    func connect(to device: CastDevice) {
            transition(to: .connecting(device))
            engine.stopDiscovery()
            
            // Simulate a network delay for the UI
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { [weak self] in
                self?.transition(to: .connected(device))
            }
        }
        
    func disconnect() {
        transition(to: .disconnected)
    }
}
