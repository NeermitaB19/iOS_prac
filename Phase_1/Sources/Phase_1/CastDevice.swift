//
//  CastDevice.swift
//  Phase_1
//
//  Created by neermita.bhattacharya@wbd.com on 03/08/26.
//
enum CastDeviceType : String {
    case tv
    case speaker
    case display
    case group
    
}

struct CastDevice{
    let id : Int
    let name : String
    var type : CastDeviceType
}

enum NetworkError : Error {
    case connectionFailed
    case invalidResponse
    case authenticationFailed
}
enum TransitionError: Error {
    case illegalTransition
}

enum ConnectionState {
    case disconnected
    case discovering
    case connecting (CastDevice) //associated values
    case connected (CastDevice)
    case reconnecting(CastDevice)
    case failed (NetworkError)
}

