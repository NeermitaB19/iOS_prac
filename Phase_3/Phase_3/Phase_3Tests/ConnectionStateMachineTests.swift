//
//  ConnectionStateMachineTests.swift
//  Phase_3
//
//  Created by neermita.bhattacharya@wbd.com on 25/08/26.
//

import XCTest
@testable import Phase_3

final class ConnectionStateMachineTests: XCTestCase {
    private let device = CastDevice(id: "1", name: "TV", type: .tv)

    func test_allowedTransitions_doNotThrow() {
        XCTAssertNoThrow(try ConnectionState.disconnected.validateTransition(to: .discovering))
        XCTAssertNoThrow(try ConnectionState.discovering.validateTransition(to: .connecting(device)))
        XCTAssertNoThrow(try ConnectionState.connecting(device).validateTransition(to: .connected(device)))
        XCTAssertNoThrow(try ConnectionState.connecting(device).validateTransition(to: .failed(.connectionFailed)))
        XCTAssertNoThrow(try ConnectionState.connecting(device).validateTransition(to: .disconnected))
        XCTAssertNoThrow(try ConnectionState.connected(device).validateTransition(to: .disconnected))
        XCTAssertNoThrow(try ConnectionState.connected(device).validateTransition(to: .reconnecting(device)))
        XCTAssertNoThrow(try ConnectionState.reconnecting(device).validateTransition(to: .connected(device)))
        XCTAssertNoThrow(try ConnectionState.reconnecting(device).validateTransition(to: .disconnected))
        XCTAssertNoThrow(try ConnectionState.failed(.connectionFailed).validateTransition(to: .discovering))
    }

    func test_illegalTransitions_throw() {
        XCTAssertThrowsError(try ConnectionState.disconnected.validateTransition(to: .connected(device)))
        XCTAssertThrowsError(try ConnectionState.connected(device).validateTransition(to: .discovering))
        XCTAssertThrowsError(try ConnectionState.discovering.validateTransition(to: .connected(device)))
        XCTAssertThrowsError(try ConnectionState.disconnected.validateTransition(to: .disconnected)) // no self-loop
    }

    func test_thrownError_isIllegalTransition() {
        do {
            try ConnectionState.disconnected.validateTransition(to: .connected(device))
            XCTFail("expected a throw")
        } catch {
            XCTAssertTrue(error is TransitionError)
        }
    }
}
