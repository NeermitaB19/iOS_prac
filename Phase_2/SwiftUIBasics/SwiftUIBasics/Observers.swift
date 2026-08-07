//
//  Observers.swift
//  SwiftUIBasics
//
//  Created by neermita.bhattacharya@wbd.com on 07/08/26.
//

import Foundation
import SwiftUI
import Combine
// MARK: OBSERVABLEOBJECT
/*
 For objects - ObservableObject and properties must have @Published
 
 @StateObject - when u create an object and use it
 
 @ObservedObject - when someone else cretes the object and u observe it
 
 
 */

struct Observers: View {
    var body: some View {
       Text("Hello")
    }
}
class UserProfile : ObservableObject{
    @Published var name : String = "Neermita"
}
struct Child : View{
    @Binding var count: Int
    var body : some View{
        Button("Add"){
            self.count+=1
        }
        Button("Subtract"){
            self.count-=1
        }
    }
}

struct ProfileView : View {
    @State private var count : Int = 0
    @StateObject var profile = UserProfile()

    var body : some View{
        Text("Hello, \(profile.name)")
        Child(count: $count)
        Text("Count: \(count)")
        }

}

#Preview {
    ProfileView()
}


