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
    //used with the mvvm pattern to represent the viewmodel layer. use when u have data that needs to be shared across multiple views or needs to persist beyond the lifetime of a single view.
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
    @State  var count : Int = 0
    //use for managing simple, view-specific state that doesn't need to be shared with other views or persisted.
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


