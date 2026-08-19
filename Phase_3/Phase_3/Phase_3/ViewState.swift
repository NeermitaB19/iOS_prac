//
//  ViewState.swift
//  Phase_3
//
//  Created by neermita.bhattacharya@wbd.com on 19/08/26.
//

import Foundation

enum ViewState<Value> {
    case idle
    case loading
    case loaded(Value)
    case failed(String)
}
