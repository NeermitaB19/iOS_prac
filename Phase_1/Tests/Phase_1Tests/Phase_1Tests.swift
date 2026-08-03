import Testing
@testable import Phase_1

@Test
func diconnectedToDiscovering() async throws {
    do{
        try validTransition(from: .disconnected, to: .discovering)
        print("Valid transition")
    }
    catch{
        print("Error: ", error)
    }
}

@Test
func disconnectedToConnected() async throws{
    let tv = CastDevice(
        id: 100,
        name: "Living Room",
        type: .tv
    )

    do {
        try validTransition(from: .disconnected, to: .connected(tv))
    }
    catch{
        print("Error: ", error)
    }
}

@Test
func disconnectedToReconnecting() async throws{
    let tv = CastDevice(
        id: 100,
        name: "Living Room",
        type: .tv
    )

    do {
        try validTransition(from: .disconnected, to: .reconnecting(tv))
    }
    catch{
        print("Error: ", error)
    }
}

@Test
func failedoDiscovering() async throws{
    
    let NetError = NetworkError.connectionFailed

    do {
        try validTransition(from: .failed(NetError), to: .discovering)
        print("Valid transition: \(ConnectionState.failed(NetError)) -> \(ConnectionState.discovering)")
    }
    catch{
        print("Error: ", error)
    }
}
