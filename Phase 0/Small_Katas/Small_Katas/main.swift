//
//  main.swift
//  Small_Katas
//
//  Created by neermita.bhattacharya@wbd.com on 28/07/26.
//

import Foundation

func clock(_ time: Int) -> String {
    let min = (time/60)
    let sec = (time%60)
    return String(format: "%02d:%02d", min, sec)
}

print(clock(145))
