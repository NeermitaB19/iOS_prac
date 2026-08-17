//
//  Models.swift
//  Phase_3
//
//  Created by neermita.bhattacharya@wbd.com on 12/08/26.
//

import Foundation
import Combine
 
enum CastDeviceType : String {
    case tv, speaker, display, group
}

struct CastDevice : Identifiable, Equatable{
    let id : String
    let name : String
    var type : CastDeviceType = .tv
}

// equatble works by default for enums and structs; for classes manually implement
enum NetworkError : Error, Equatable {
    case connectionFailed
    case invalidResponse
    case authenticationFailed
}

enum TransitionError : Error{
    case illegalTransition
}

enum ConnectionState : Equatable{
    case disconnected
    case discovering
    case connecting(CastDevice)
    case connected(CastDevice)
    case reconnecting(CastDevice)
    case failed(NetworkError)
}

extension ConnectionState {
    func validateTransition(to next : ConnectionState) throws {
        switch (self, next) {
        case (.disconnected, .discovering): return
        case (.discovering, .connecting(_)): return
        case (.connecting(_), .connected(_)): return
        case (.connecting(_), .failed(_)): return
        case (.connecting(_), .disconnected): return
        case (.reconnecting(_), .disconnected): return
        case (.reconnecting(_), .connected(_)): return
        case (.connected(_), .disconnected): return
        case (.connected(_), .reconnecting(_)): return
        case (.failed(_), .discovering): return
        default:
            throw TransitionError.illegalTransition
        }
    }
}
