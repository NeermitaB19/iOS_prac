//
//  Trying.swift
//  SwiftUIBasics
//
//  Created by neermita.bhattacharya@wbd.com on 10/08/26.
//


// Source - https://stackoverflow.com/q/74484318
// Posted by Stoic, modified by community. See post 'Timeline' for change history
// Retrieved 2026-08-10, License - CC BY-SA 4.0
import Foundation
import SwiftUI
import Combine
struct MyView: View {
    @State var backgroundIsRed = false

    var body: some View {
        ZStack {
            if backgroundIsRed {
                Color.red
            } else {
                Color.green
            }
        }
        .onTapGesture { backgroundIsRed.toggle() }

    }
}

#Preview{
    MyView()
}
