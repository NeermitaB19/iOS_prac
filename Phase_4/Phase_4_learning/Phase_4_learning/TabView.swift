//
//  TabView.swift
//  Phase_4_learning
//
//  Created by neermita.bhattacharya@wbd.com on 20/08/26.
//
import SwiftUI
import Combine
import Foundation
import CoreData

struct TabViews: View {
    @Environment(\.managedObjectContext)
    private var viewContext

    @FetchRequest(
        sortDescriptors: []
    )
    private var tasks: FetchedResults<Entity>


    @AppStorage("selectedTab")
    private var selectedTab = 0
    
    @AppStorage("isDarkModeEnabled")
    private var isDarkModeEnabled = false
    
 

    
    var body: some View {
        VStack {
            TabView(selection: $selectedTab) {
                Text("First Tab")
                    .tabItem {
                        Image(systemName: "arrowshape.turn.up.backward.2")
                        Text("Tab 1")
                    }
                    .tag(0)
                
                Text("Second Tab")
                    .tabItem {
                        Image(systemName: "heart.fill")
                        Text("Tab 2")
                    }
                    .tag(1)
                
                Text("Third Tab")
                    .tabItem {
                        Image(systemName: "house")
                        Text("Tab 3")
                    }
                    .tag(2)
            }
            
            Toggle("Dark Mode", isOn: $isDarkModeEnabled)
                .padding()
            
            Button("Add Task") {

                let task = Entity(context: viewContext)
                print(type(of: task))


                task.id = UUID()
                task.title = "TEST TASK"
                task.isCompleted = false

                print("Created:")
                print("ID:", task.id ?? UUID())
                print("Name:", task.title ?? "nil")
                print("Completed:", task.isCompleted)

                do {
                    try viewContext.save()
                    print("✅ SAVED")
                } catch {
                    print("❌ SAVE FAILED")
                    print(error.localizedDescription)
                }
            }

            
            List(tasks) { task in

                            HStack {
                                Text(task.title ?? "No name")

                                Spacer()

                                Image(
                                    systemName: task.isCompleted
                                        ? "checkmark.circle.fill"
                                        : "circle"
                                )
                            }
                        }
            .preferredColorScheme(
                isDarkModeEnabled ? .dark : .light)
            
            
        }
    }
}
    
#Preview {
    TabViews()
}
