//
//  Theme.swift
//  Phase_3
//
//  Created by neermita.bhattacharya@wbd.com on 26/08/26.
//

import SwiftUI

enum Theme {
    enum Palette {
        static let background    = Color.black
        static let surface       = Color(white: 0.15)
        static let surfaceMuted  = Color.gray.opacity(0.3)
        static let primaryText   = Color.white
        static let secondaryText = Color.gray
        static let accent        = Color.cyan
        static let live          = Color.red
        static let success       = Color.green
        static let connected     = Color.blue
    }
    enum Spacing {
        static let xxs: CGFloat = 2
        static let xs:  CGFloat = 4
        static let s:   CGFloat = 8
        static let m:   CGFloat = 12
        static let l:   CGFloat = 16
        static let xl:  CGFloat = 20
        static let controlGap: CGFloat = 44
    }
    enum Radius {
        static let s: CGFloat = 6
        static let m: CGFloat = 8
        static let l: CGFloat = 12
    }
    enum Size {
        static let artworkThumb: CGFloat = 48
        static let posterW: CGFloat = 130
        static let posterH: CGFloat = 195
        static let playerArea: CGFloat = 250
    }
}
