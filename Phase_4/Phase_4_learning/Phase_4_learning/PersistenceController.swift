//
//  PersistenceController.swift
//  Phase_4_learning
//
//  Created by neermita.bhattacharya@wbd.com on 20/08/26.
//

import CoreData

class PersistenceController {

    static let shared = PersistenceController()

    let container: NSPersistentContainer

    init() {
        container = NSPersistentContainer(
            name: "ModelNemo"
        )

        container.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Core Data failed: \(error)")
            }
        }
    }
}
