//
//  Trying.swift
//  SwiftUIBasics
//
//  Created by neermita.bhattacharya@wbd.com on 10/08/26.
//


// Source - https://stackoverflow.com/q/74484318
// Posted by Stoic, modified by community. See post 'Timeline' for change history
// Retrieved 2026-08-10, License - CC BY-SA 4.0
import Foundation
import SwiftUI
import Combine
struct MyView: View {
    @State var backgroundIsRed = false

    var body: some View {
        ZStack {
            if backgroundIsRed {
                Color.red
            } else {
                Color.green
            }
        }
        .onTapGesture { backgroundIsRed.toggle() }

    }
}

#Preview{
    MyView()
}

/*
 Single Responsibility Principle (SRP):
 The SRP states that a class should have only one reason to change, meaning it should have a single responsibility. By keeping classes focused on a specific task, we achieve higher cohesion and reduce the potential for code duplication or bloated classes. This principle helps us to keep our classes as clean as possible.
one class handles user related operations, one handles view updates
 */


/* open closed principle
 The OCP states that software entities should be open for extension but closed for modification. This principle encourages the use of abstraction and polymorphism, allowing new functionality to be added without modifying existing code.
 use protocols (area func for diff shapes)
 
 */

/*
 Liskov Substitution Principle (LSP):
 The LSP states that objects of a superclass should be replaceable with objects of its subclasses without affecting the correctness of the program. In other words, the subclasses should be able to substitute their parent classes without causing unexpected behavior.
 override func x()
 
 
 */


/*
 Interface Segregation Principle (ISP):
 The ISP states that clients should not be forced to depend on interfaces they do not use. It promotes the idea of creating focused, cohesive interfaces, tailored to the specific needs of clients, to avoid unnecessary dependencies.
 
 we have separate interfaces for printing and scanning. The AllInOnePrinter class implements both interfaces since it supports both functionalities. On the other hand, the SimplePrinter class only implements the Printer interface, as it does not support scanning. This way, clients can depend on the specific interfaces they require, reducing unnecessary dependencies.
 
 */


/*
 Dependency Inversion Principle (DIP):
 The DIP states that high-level modules should not depend on low-level modules; both should depend on abstractions. This principle encourages decoupling and promotes the use of interfaces or protocols to define contracts between components.
let datamanager class depend on a protocol instead of actual databases
 
 protocol Database {
      func saveData(_ data: Data)
 }

 class DataManager {
      let database: Database


      init(database: Database) {
           self.database = database
      }

      func save(data: Data) {
           database.saveData(data)
      }
 }
 */

/*
 MVC - model + controller + view
 Contoller could end up doing anything tbh
 
 
 MVVM is about separating UI from presentation logic
 easy to test viewmodel as separate from ui
 
 VIPER = more separation with responsibilities, instead of one large viewcontroller.
 but too many files and protocols
 for one screen we may hjave - LoginView
 LoginViewController
 LoginPresenter
 LoginInteractor
 LoginRouter
 LoginEntity
 LoginProtocols

 
 CLEAN - how should the entire application be structured and how should dependencies flow
 ┌───────────────────────────────┐
 │          Presentation         │
 │       View / ViewModel        │
 ├───────────────────────────────┤
 │             Domain            │
 │       Use Cases / Models      │
 ├───────────────────────────────┤
 │             Data              │
 │   Repository / API / DB       │
 └───────────────────────────────┘
 DataManager
      ↓
 SQLiteDatabase
 DataManager depends on the db
 
 
 invert
 
 DataManager
      ↓
   Database       ← protocol
      ↑
      │
 SQLiteDatabase

 */
