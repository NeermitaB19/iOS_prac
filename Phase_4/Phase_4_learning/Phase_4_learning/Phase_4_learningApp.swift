//
//  Phase_4_learningApp.swift
//  Phase_4_learning
//
//  Created by neermita.bhattacharya@wbd.com on 18/08/26.
//

import SwiftUI
import CoreData
@main
struct Phase_4_learningApp: App {
    let persistenceController =
           PersistenceController.shared
    var body: some Scene {
        WindowGroup {
            TabViews()
                .environment(\.managedObjectContext,
                                    persistenceController.container.viewContext
                                )
        }
    }
}
