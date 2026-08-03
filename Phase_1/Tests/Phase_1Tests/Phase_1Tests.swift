import Testing
@testable import Phase_1

@Test
func test1() async throws {
    let tv = CastDevice(id : 100, name : "Living Room", type : CastDeviceType.tv )
    let result = validTransition(from: .disconnected, to: .discovering)
    
}
