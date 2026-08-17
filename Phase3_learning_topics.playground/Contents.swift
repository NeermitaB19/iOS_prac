import Cocoa

var greeting = "Hello, playground"
struct User: Codable {
    let id: Int
    let name: String
    let email: String
    let age: Int?
}
let jsonString = """
{
    "id": 1312,
    "name": "John Doe",
    "email": "john.doe@example.com",
    "age": null
}

"""
let jsonData = jsonString.data(using: .utf8)!

print(jsonData)
do {
    let decoder = JSONDecoder()
    let user = try decoder.decode(User.self, from: jsonData)
        print(user)
    print("ID: \(user.id), Name: \(user.name), Email: \(user.email), Age: \(user.age ?? 0)")
}
catch{
    print("Error decoding JSON: \(error)")
}
let jsonString2 = """
{
    "id": "1312",
    "name": "John Doe",
    "email": "john.doe@example.com",
    "age": null
}

"""
struct User2: Codable {
    let id: Int
    let name: String
    let age: Int
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case age
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        
        // Custom decoding logic for age
        if let ageString = try? container.decode(String.self, forKey: .age), let age = Int(ageString) {
            self.age = age
        } else if let ageInt = try? container.decode(Int.self, forKey: .age) {
            self.age = ageInt
        } else {
            throw DecodingError.typeMismatch(Int.self, DecodingError.Context(codingPath: [CodingKeys.age], debugDescription: "Expected age to be an Int or a String convertible to Int"))
        }
    }
}


let jsonData2 = jsonString.data(using: .utf8)!
do {
    let decoder = JSONDecoder()
    let user = try decoder.decode(User.self, from: jsonData2)

    print(user.id, type(of: user.id))
} catch {
    print("Error:", error)
}

// EnumHandling.swift
// Enums with raw values automatically conform to Codable.
// The raw value is used for encoding and decoding.
import Foundation

enum Priority: String, Codable {
    case low
    case medium
    case high
    case critical
}

enum Status: Int, Codable {
    case pending = 0
    case inProgress = 1
    case completed = 2
    case cancelled = 3
}

struct Issue: Codable {
    let id: Int
    let title: String
    let priority: Priority
    let status: Status
}

let jsonString3 = """
{
    "id": 42,
    "title": "Fix login bug",
    "priority": "high",
    "status": 1
}
"""

let jsonData3 = jsonString3.data(using: .utf8)!
let issue = try JSONDecoder().decode(Issue.self, from: jsonData3)

print("Issue: \(issue.title)")
print("Priority: \(issue.priority)")    // Output: high
print("Status: \(issue.status)")        // Output: inProgress


// MARK: higher order functions

//compactMap

let userInputs = ["10", "hello", "20", "apple", nil]
// Int($0) tries to turn the string into an integer.
// "hello" fails and becomes nil. compactMap deletes it.
let validNumbers = userInputs.map { ($0)}
print(validNumbers)

//reduce
let prices = [231,546,234,123,789]
var t = prices.reduce(0){n,m in n+m}

print(t)

//foreach
let names = ["Neermita", "John", "Sarah"]
names.forEach { print("Hello, \($0)!") }


// --------------------------------------- filter and sort



// Design pattern - reusable solution to a common software deisgning problem
/*
 Design Patterns
 │
 ├── Creational
 │     → How objects are created
 │
 ├── Structural
 │     → How objects/classes are combined
 │
 └── Behavioral
       → How objects communicate/behave

 */
/*
 
 Factory
 Problem
 You need to create different objects, but you don't want the caller to know the exact concrete class.
 */

/*
 Builder
 Problem
 An object has lots of configuration.

 Imagine:

 User(
     name: "John",
     age: 25,
     email: "...",
     address: "...",
     phone: "...",
     image: "...",
     ...
 )
 
 use builder let user = UserBuilder()
 .setName("John")
 .setAge(25)
 .setEmail("john@email.com")
 .build()

 */
//////////////////////////////////////////////////////////////////////////////

//  Single Responsibility Principle

/*
 class UserManager {

     func validateUser() {
         print("Validating user")
     }

     func saveUser() {
         print("Saving user to database")
     }

     func sendEmail() {
         print("Sending email")
     }
 }

 */
class UserValidator {
    func validate(user: User) -> Bool {
        return true
    }
}

class UserRepository {
    func save(user: User) {
        print("Saving user")
    }
}

class EmailService {
    func sendWelcomeEmail(to user: User) {
        print("Sending welcome email")
    }
}
 //Open/Closed Principle
/*
 class PaymentProcessor {

     func pay(type: String, amount: Double) {

         if type == "card" {
             print("Paying with card")
         }
         else if type == "paypal" {
             print("Paying with PayPal")
         }
         else if type == "applePay" {
             print("Paying with Apple Pay")
         }
     }
 }

 */

protocol PaymentMethod {
    func pay(amount: Double)
}
class CreditCardPayment: PaymentMethod {

    func pay(amount: Double) {
        print("Paid ₹\(amount) using Credit Card")
    }
}
class PayPalPayment: PaymentMethod {

    func pay(amount: Double) {
        print("Paid ₹\(amount) using PayPal")
    }
}
class PaymentProcessor {

    func process(
        payment: PaymentMethod,
        amount: Double
    ) {
        payment.pay(amount: amount)
    }
}
// Liskov Substitution Principle
protocol Bird {
    func eat()
}
protocol Flyable {
    func fly()
}
class Eagle: Bird, Flyable {

    func eat() {
        print("Eagle eating")
    }

    func fly() {
        print("Eagle flying")
    }
}
class Penguin: Bird {

    func eat() {
        print("Penguin eating")
    }
}
// Interface Segregation Principle - Don't force a class to implement methods it doesn't need.

/*
 protocol Worker {
     func work()
     func eat()
     func sleep()
 }
 class Robot: Worker {

     func work() {
         print("Robot working")
     }

     func eat() {
         // Robot doesn't eat!
     }

     func sleep() {
         // Robot doesn't sleep!
     }
 }

 
 */

// split protocol
protocol Workable {
    func work()
}

protocol Eatable {
    func eat()
}

protocol Sleepable {
    func sleep()
}
class Robot: Workable {

    func work() {
        print("Robot working")
    }
}

// Dependency Inversion Principle - High-level code should depend on abstractions, not concrete implementations.
/*
 class SQLiteDatabase {

     func save(data: Data) {
         print("Saving to SQLite")
     }
 }

 class DataManager {

     let database = SQLiteDatabase()

     func save(data: Data) {
         database.save(data: data)
     }
 }

 */
protocol Database {
    func save(data: Data)
}
class SQLiteDatabase: Database {

    func save(data: Data) {
        print("Saving to SQLite")
    }
}
class DataManager {

    private let database: Database

    init(database: Database) {
        self.database = database
    }

    func save(data: Data) {
        database.save(data: data)
    }
}


//MARK: JSON

@propertyWrapper
struct StringDecodable : Codable{
    var wrappedValue : String
    init(wrappedValue : String){
        self.wrappedValue = wrappedValue
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        
        if let stringValue = try? container.decode(String.self){
            wrappedValue = stringValue
        }
        else if let intValue = try? container.decode(Int.self){
            wrappedValue = String(intValue)
        }
        else if let doubleValue = try? container.decode(Double.self){
            wrappedValue = String(doubleValue)
        }
        else {
            throw DecodingError.typeMismatch(
                String.self,
                DecodingError.Context(
                    codingPath: decoder.codingPath,
                    debugDescription: "Expected a String or convertible numeric value."
                )
            )
        }
        
    }
}


struct Post: Codable, Identifiable {
    let userId: Int
    @StringDecodable var id: String // Handles Int-to-String conversion automatically
    let title: String
    let body: String
}



func fetch() async throws -> [Post]{
    guard let url = URL(string: "https://jsonplaceholder.typicode.com/posts")
    else {
        throw URLError(.badURL)
    }
    let (data, response) = try await URLSession.shared.data(from: url)
    guard let response = response as? HTTPURLResponse,
              200..<300 ~= response.statusCode else {
            throw URLError(.badServerResponse)
        }
    return try JSONDecoder().decode([Post].self, from: data)


}


Task {
    do {
        let posts = try await fetch()
        print("Successfully fetched \(posts.count) posts!")
        if let first = posts.first {
            print("First Post ID: \(first.id) and type: \(type(of: first.id))")
        }
        print("100th post: \(posts[99].title)")
    } catch {
        print("Error: \(error)")
    }
}

//When the decoder tries to decode id, it sees @StringDecodable, looks at the wrapper, and says, "Hey, run init(from decoder: Decoder) using this chunk of JSON data." Inside that initializer, our code checks if the JSON value is an Int, Double, or String, converts it, and saves it into wrappedValue.
import TabularData
Task {
    do {
        let allPosts = try await fetch()
        
        // Convert your [Post] array into a DataFrame
        var dataframe = DataFrame()
        dataframe.append(column: Column(name: "userId", contents: allPosts.map { $0.userId }))
        dataframe.append(column: Column(name: "id", contents: allPosts.map { $0.id }))
        dataframe.append(column: Column(name: "title", contents: allPosts.map { $0.title }))
        dataframe.append(column: Column(name: "body", contents: allPosts.map { $0.body }))
        
        // Print the DataFrame table view to your console
        print(dataframe)
        
    } catch {
        print("Error: \(error)")
    }
}
