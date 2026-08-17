//
//  Environment.swift
//  SwiftUIBasics
//
//  Created by neermita.bhattacharya@wbd.com on 14/08/26.
//

import SwiftUI
import Combine
// 1. Create an ObservableObject that holds shared data
class UserSession: ObservableObject {
    @Published var username = "Alice"
}

// 2. A child view that receives the data via @EnvironmentObject
struct ProfileView2: View {
    @EnvironmentObject var session: UserSession // Tunes into the environment

    var body: some View {
        VStack(spacing: 12) {
            Text("Hello, \(session.username)!")
                .font(.title2)
            if session.username == "Bob"{
                Button("Change Name to Alice") {
                    session.username = "Alice"
                } .buttonStyle(.bordered)
                
            }
            else{
                Button("Change Name to Bob") {
                    session.username = "Bob"
                }
                
                .buttonStyle(.bordered)
            }}
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(10)
    }
}

// 3. Root view that creates the object and injects it
struct MainView: View {
    // Create the source of truth object
    @StateObject private var session = UserSession()

    var body: some View {
        VStack(spacing: 20) {
            Text("Main View - Current User: \(session.username)")
                .font(.headline)
            
            // Embed ProfileView. Notice we do NOT pass session via init(session: ...)
            ProfileView2()
        }
        .padding()
        // Inject the object into the environment for this view and all its children
        .environmentObject(session)
    }
}

#Preview {
    MainView()
}
