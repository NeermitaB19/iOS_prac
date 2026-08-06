
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


class UserProfile : ObservableObject{
    @Published var name : String = "Neermita"
}

struct ProfileView : View {
    @StateObject var profile : UserProfile
    
    var body : some View{
        Text("Hello, \(profile.name)")
    }
}

#Preview {
    ProfileView(profile: UserProfile())
}
