//
//  ConnectionValidator.swift
//  Phase_1
//
//  Created by neermita.bhattacharya@wbd.com on 03/08/26.
//

//model

func validTransition(from current : ConnectionState, to next : ConnectionState) -> Bool {
    switch (current, next){
        case (.disconnected, .discovering):
            return true
        case (.discovering, .connecting(_)):
            return true
        case (.connecting(_), .connected(_)):
            return true
        case (.connecting(_), .failed(_)):
            return true
        case (.connecting(_), .disconnected):
            return true
        case (.reconnecting, .disconnected):
            return true
        case (.reconnecting, .connected(_)):
            return true
        case (.connected(_), .disconnected):
            return true
        case (.connected(_), .reconnecting):
            return true
        case (.failed(_), .discovering):
            return true
        default :
            return false
    }
}
