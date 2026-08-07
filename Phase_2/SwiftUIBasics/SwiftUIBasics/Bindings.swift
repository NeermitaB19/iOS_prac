//
//  Untitled.swift
//  SwiftUIBasics
//
//  Created by neermita.bhattacharya@wbd.com on 07/08/26.
//

import Combine
import Foundation
import SwiftUI


struct Bindings: View {
    @State private var name = ""
    var body: some View {
        Form{
            TextField("Enter your name", text: $name)
        }
        Text("Your name is \(name)")
        Form {
            ForEach(0..<10) { number in
                Text("Row \(1+number)")
            }
        }
        TabView{
            Text("Home").tabItem{
                Label("Home", systemImage: "house.fill")
            }
            Text("Messages").tabItem{
                Label("Messages", systemImage: "message.fill")
            }
            Text("Search").tabItem{
                Label("Search", systemImage: "magnifyingglass")
            }
            Text("Profile").tabItem {
            Label("Profile", systemImage: "person.crop.circle.fill")
                            }

        }
    }
}
#Preview {
    Bindings()
}
