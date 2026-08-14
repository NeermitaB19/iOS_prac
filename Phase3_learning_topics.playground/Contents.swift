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
