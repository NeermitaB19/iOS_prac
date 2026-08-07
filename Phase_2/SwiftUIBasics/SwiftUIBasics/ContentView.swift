
//
//  ContentView.swift
//  CastDemo
//
//  Created by neermita.bhattacharya@wbd.com on 05/08/26.
//

import SwiftUI
import Combine
struct ContentView: View {
    var body: some View {
       Text("Hello")
    }
}
 // MARK: STATE and BINDING
struct ChildView : View {
    @Binding var value : Int
    var body : some View {
        VStack {
            Text("Value in childview: \(value)")
            Button("Increment"){
                value+=1
            }.padding()
            Button("Decrement"){
                value-=1
            }
        }.padding()
    }
}
// child takes a binding to parentValue, allowing it to both read and modify the value
struct ParentView: View {
    @State private var parentValue : Int = 0
    
    var body : some View{
        VStack{
            Text("Value in parentview: \(parentValue)")
            ChildView(value: $parentValue)
        }
    }
}


#Preview {
    ParentView()
}
