import Cocoa
import XCTest

var greeting = "Hello, playground"
// UIKit has AppDelegate, SceneDelegate, ViewController, Main, LaunchScreen files


//AppDelegate - entry point of app. Initiate third party services, bug reporting, monitor for memory warning etc,. Bloated and Antipattern type
//it is singleton - iOS instantiates your AppDelegate class once when the app launches only. We never use AppDelegate()

// SceneDelegate
//- holds the window. Single scene with single window
// when window enters background or foreground?
// customize how the app will be at launch (which viewcontroller is presented)


//UIViewController and UIView
//ViewController - takes care of the view + presentation lifecycle
//MARK: TableView
/*
 single column containing vertically scrolling content - tableview
 TableView is instance of UITableView class which inherits UIScrollView class
 Row is simulated by the object of the UITableViewCell class
 */
//MARK: CollectionView
/*
 Gets the data from DataSource object which conforms with the UICollectionViewDataSource protocol
 */



//MARK: Hashable

//make it easy to commpare and manage your data structures
// The Hashable protocol allows instances to be efficiently located and compared in collections like Set and Dictionary by generating unique hash values.
struct Person: Hashable {
 let name: String
 let age: Int
}

let person1 = Person(name: "Alice", age: 30)
let person2 = Person(name: "Bob", age: 25)
let peopleSet: Set<Person> = [person1, person2]

if peopleSet.contains(Person(name: "Alice", age: 30)) {
 print("Found Alice!")
}
//MARK: DATA PERSISTENCE
//UserDefaults: lightweight, key-value store  intended for small amounts of non sensitive data like user prefs. Core Data is a robust object-graph and persistence framework designed for complex and huge datasets.

//UserDefaults - Flattened Key-value store.

//Core Data - object graph (backed by SQLite database). Relational, offline-first dbs.


// Access the shared singleton instance
let defaults = UserDefaults.standard

// Writing Data
defaults.set(true, forKey: "isDarkModeEnabled")
defaults.set("John Doe", forKey: "username")

// Reading Data
let isDark = defaults.bool(forKey: "isDarkModeEnabled") // Defaults to false if key missing
let user = defaults.string(forKey: "username") ?? "Guest"
print(isDark)
print(user)

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()

    let container: NSPersistentContainer

    init() {
        container = NSPersistentContainer(name: "ModelNemo") // Matches your .xcdatamodeld filename
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
    }
}


func Add(_ a:Int, _ b:Int)-> Int{
    return a+b
}

func testAdd(){
//    XCAssertEqual(Add(2,3),5)
}

//Unit testing means testing one small piece of logic in isolation
/*
 Arrange
    ↓
 Create/setup required objects

 Act
    ↓
 Call the code being tested

 Assert
    ↓
 Check that the result is correct

 */


/*
 XCTAssertTrue(condition)
 XCTAssertNil(value)
 XCTAssertNotEqual(actual, expected)

 */

/* use setUp if all testcases need a common resource (but fresh instance)
 final class CalculatorTests: XCTestCase {

     var calculator: Calculator!

     override func setUp() {
         super.setUp()

         calculator = Calculator()
     }

     override func tearDown() {
         calculator = nil

         super.tearDown()
     }

     func testAdd() {
         XCTAssertEqual(
             calculator.add(2, 3),
             5
         )
     }
 }

 */

//import XCTest
//@testable import MyApp
//
//final class CalculatorTests: XCTestCase {
//
//    func testAddition() {
//
//        let calculator = Calculator()
//
//        let result = calculator.add(2, 3)
//
//        XCTAssertEqual(result, 5)
//    }
//}


enum LoginError: Error {
    case invalidCredentials
}

func login(username: String, password: String) throws {
    if password.isEmpty {
        throw LoginError.invalidCredentials
    }
}
func testLogin_emptyPassword_throwsError() {
    XCTAssertThrowsError(
        try login(username: "john", password: "")
    )
}

do {
    try login(username: "john", password: "")
    print("Login succeeded")
} catch {
    print("Login failed:", error)
}

//MARK: Testing optionals
func findUser() -> String? {
    return "Johnn"
}
func testFindUser_returnsUser() {
    let user = findUser()

    XCTAssertNotNil(user)
    XCTAssertEqual(user, "John")
}
let users = ["John", "Sarah", "Mike"]

XCTAssertEqual(users.count, 3)
XCTAssertTrue(users.contains("John"))
XCTAssertFalse(users.contains("Bob"))
XCTAssertEqual(
    users,
    ["John", "Sarah", "Mike"]
)
let username = "John"
XCTAssertEqual(username, "John")
XCTAssertNotEqual(username, "Mike")
XCTAssertTrue(username.contains("oh"))

XCTAssertEqual(
    0.301,
    0.3,
    accuracy: 0.0001
)

// XCTest return types are always void, they are not a normal function

















// FakeCastEngine -publishers-> Interactor -@Published viewState-> View
// Interactor has all logic like play/pause, mapping etc,.

//Dependency Injection (DI) — "give the object what it needs, don't let it build it"
/*
 class CastViewModel {
     private let engine: FakeCastEngine
     init(engine: FakeCastEngine) {   // engine is passed in ("injected")
         self.engine = engine
     }
 }
 */
//That's it. "Dependency injection" is a fancy name for a simple idea: pass in the things an object depends on through its init, instead of the object creating them internally.

/*
 Publisher = the YouTube channel. It emits values over time. You can subscribe to it, but you can't post to it.
 Subscriber = you. You react each time a new value arrives.
 Subject = a special publisher that you can also push values into. It's the channel plus the "upload" button.
 */

/*
 devicesSubject is a Subject — the engine pushes new device lists into it whenever discovery finds devices:


 self.devicesSubject.send(foundDevices)
 .send(...) = "publish this new value to everyone subscribed." That's the "upload" button.

 devicesPublisher is the read-only view of that subject. .eraseToAnyPublisher() strips away the "upload" ability, so the outside world can listen but can't .send(...).
 This is a deliberate design: the engine keeps the writable Subject private, and exposes only a read-only Publisher. Nobody outside the engine can fake device data — only the engine controls what's emitted. It's the same private/public discipline as @Published private(set) var state.
 */

//.debounce(...) — "if values arrive in a flurry, wait 0.5s and only take the last one" (avoids flicker)

/* playbackStateSubject is writable and it exposes playbackStatePublisher (read)*/

