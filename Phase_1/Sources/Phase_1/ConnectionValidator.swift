//
//  ConnectionValidator.swift
//  Phase_1
//
//  Created by neermita.bhattacharya@wbd.com on 03/08/26.
//

//model

func validTransition(from current : ConnectionState, to next : ConnectionState) throws -> () {
    switch (current, next){
        case (.disconnected, .discovering):
            return
        case (.discovering, .connecting(_)):
            return
        case (.connecting(_), .connected(_)):
            return
        case (.connecting(_), .failed(_)):
            return
        case (.connecting(_), .disconnected):
            return
        case (.reconnecting, .disconnected):
            return
        case (.reconnecting, .connected(_)):
            return
        case (.connected(_), .disconnected):
            return
        case (.connected(_), .reconnecting):
            return
        case (.failed(_), .discovering):
            return
        default :
        throw  TransitionError.illegalTransition
            
    }
}
