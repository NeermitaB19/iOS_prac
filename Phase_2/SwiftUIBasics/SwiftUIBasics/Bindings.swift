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
    let students = ["Harry", "Ron", "Hermione"]
    @State private var selectedStudent = "Harry"
    var body: some View {
        
        VStack{
            Form{
                TextField("Enter your name", text: $name)
            }
       
            Text("Your name is \(name)")
            Form {
                ForEach(0..<4) { number in
                    Text("Row \(1+number)")
                }
            }
          
                Form{
                    Picker("Select your student", selection: $selectedStudent){
                        ForEach(students, id: \.self) {
                            Text($0)
                                    
                        
                    }}
                    }
            Text("Selected student: \(selectedStudent)")
            
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
}
#Preview {
    Bindings()
}
