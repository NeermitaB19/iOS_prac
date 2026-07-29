//
//  main.swift
//  CMD_SWIFT
//
//  Created by neermita.bhattacharya@wbd.com on 26/07/26.
//

import Foundation

// VARIABLES

print("Hello, World!")
var greeting="hi?"
print(greeting)

let hi="hello" //immutable

var names = ["Alice", "Bob", "Charlie"] //arrays are structures
names.append("David")
print(names)

var foo = "Foo"
var foo2=foo
foo2 = "Foo2"
print(foo)
print(foo2)

//stuctures are value types
//classes are reference types


let oldArray=NSMutableArray( //instance of a class
    array: [
        "Foo",
        "Bar"
    ]
    ) //cant do oldArray =[] (reassignment)

// prevention of internal mutability of let constant applies only to value types
// prevention of reassignment of let constant applies both to value and ref types

oldArray.add(1)
print(oldArray)
var newArray=oldArray
newArray.add("hi")
print(oldArray)
print(newArray)

func changeTheArray(_ array: NSArray){
    
    
    let copy = array as! NSMutableArray
    copy.add("Baz")
}
changeTheArray(oldArray)
print(oldArray)


// OPERATORS /////////////////////////////////////////////////////////////////
let myAge=20
let yourAge=23
if myAge>yourAge{
    print("True")
    
}
else if myAge<yourAge{
    print("No")
    
}
else{
    print("same age!")
}

// 1. unary prefix
let Foo = !true
// 2. unary postfix
let name = Optional("Vandad")
let unaryPostFix = name!
print(type(of:name))
print(type(of:unaryPostFix))
// 3. binary infix
let result = 1+2
// 4. ternary
let message = myAge > yourAge
? print("Im older")
: print("Im younger")

print("Your age is \(yourAge)")

// IF AND ELSE
let myName="Foo"
if myAge == 20 || myName == "Foo"{
    print("YES")
}

// FUNCTIONS ///////////////////////////////////////////////////////////
func noArgumentsAdNoReturnValue(){
    print("Function idk")
}

noArgumentsAdNoReturnValue()

func plusTwo(value: Int){
    let newValue = value + 2
    print(newValue)
    
}
plusTwo(value: 30)


func newPlusTwo(value: Int) -> Int {
    
    let newValue = value + 2090
    return newValue
}

print(newPlusTwo(value: 30))

func customAdd(
    value1: Int, value2: Int) -> Int {
        return value1 + value2
    }
print("Addition result: ",customAdd(value1:999, value2:343))

func customMinus(_ lhs: Int, _ rhs: Int) -> Int{
    
    lhs-rhs
}
let sub = customMinus(40, 60)
print("Subtraction: ", sub)

struct Person{
    @discardableResult
    func getAge() -> Int {
        return 65
        
    }
    func doSomething(){
        getAge()
    }
}
var person = Person()
print(person.getAge())

//functions, closures and classes are reference types
// arrays, dictionaries, sets, structs, enums, tuples, int, float, bool, string are vakue types

// 'to' is the external label. 'user' is the internal label.
func sendGreeting(to user: String) {
    // Inside the function, you use the internal label
    print("Hello, \(user)!")
}

// When calling the function, you use the external label
sendGreeting(to: "Alice")

func doSomething(with value: Int) -> Int {
    func mainLogic(with value: Int) -> Int {
        value + 2
    }
    return mainLogic(with: value + 3)
}

print(doSomething(with: 10))
let number = 120
print(number.isMultiple(of: 3))

// practice
func convert(_ celsius: Double) -> Double {
    
    let cel = celsius
    let fah = cel*9/5 + 32
    return fah
}
print(convert(100))
// DATA TYPES /////////////////////////////////////////////////////////////
var someName="Neermita"
print(someName.uppercased())
print(someName.count)
print(someName.hasPrefix("N"))
let num = 10203324325
print("Is \(num) a mutiple of 3: ",num.isMultiple(of: 3))

// ARRAYS /////////////////////////////////////////////////////////////////
var albums = ["Pop", "Rock"]
albums.append("Metal")

print(albums.count)
albums.remove(at:0)
print(albums.count)
print(albums.contains("Metal"))
print("Sorted array: ",albums.sorted())
print("Reversed array: ", albums.reversed())

var threes = Array(repeating: 0, count:3)
print(threes)

// DICTIONARIES ///////////////////////////////////////////////////////////
let employee2 = ["name": "Taylor Swift", "job": "Singer", "location": "Nashville"]
print(employee2["name"])
print(employee2["idkey"])
print(employee2["name", default:"Unknown"])
print(employee2["idkey", default:"Unknown"])

var height = [String: Int]()
height["Taylor"] = 180
print(height.count)
print(height.removeAll())

// SETS ///////////////////////////////////////////////////////////////////

let people = Set(["Denzel Washington", "Tom Cruise", "Nicolas Cage", "Samuel L Jackson"])
print(people)

var peoples = Set<String>()
peoples.insert("Denzel Washington")
peoples.insert("Tom Cruise")
print(peoples.count)
print(peoples.contains("Denzel Washington"))
print(peoples.sorted())

// ENUMS ////////////////////////////////////////////////////////////////

enum Weekday {
    case monday
    case tuesday
    case wednesday
    case thursday
    case friday
    case saturday
    case sunday
}
var day = Weekday.monday
print(day)

// TYPE ANNOTATIONS /////////////////////////////////////////////////////
let surname: String = "Lasso"
var score: Int = 0
var isStudent: Bool = true
var album: [String] = ["Red", "Fearless"]
var user: [String: String] = ["id": "@twostraws"]

//type inference
var clues = [String]()
//type annotation
var cities: [String] = []

enum UIStyle {
    case light, dark, system
}

var style = UIStyle.light

let username: String
username = "@nemo"

enum Weather {
    case sun, rain, wind, snow, unknown
}
// IF-ELSE & SWITCH CASE //////////////////////////////////////////////////////////
func weather(_ weather: Weather){
    
    
    if weather == Weather.sun{print("Its sunny")}
    else if weather == Weather.rain{print("Its raining")}
    else if weather == Weather.wind{print("Its windy")}
    else if weather == Weather.snow{print("Its snowing")}
    else{print("Unknown")}
    
    switch weather{
    case .sun: print("Its sunny!!")
    case .rain: print("Its raining!!")
    case .wind: print("Its windy!!")
    case .snow: print("Its snowing!!")
    default: print("Unknown")
    }
    
    let day = 5
    print("My true love gave to me…")

    switch day {
    case 5:
        print("5 golden rings")
        fallthrough
    case 4:
        print("4 calling birds")
        fallthrough
    case 3:
        print("3 French hens")
        fallthrough
    case 2:
        print("2 turtle doves")
        fallthrough
    default:
        print("A partridge in a pear tree")
    }
}

weather(Weather.rain)

// LOOPS ////////////////////////////////////////////////////////////////

for x in 1...4{
    print(x*2)
}
for i in 1..<5 {
    print("Counting 1 up to 5: \(i)")
}

var countdown=5
while countdown>0{
    print(countdown)
    countdown-=1
}
let id = Int.random(in: 1...1000)


let filenames = ["me.jpg", "work.txt", "sophie.jpg", "logo.psd"]

for filename in filenames {
    if filename.hasSuffix(".jpg") == false {
        continue
    }

    print("Found picture: \(filename)")
}
let error : (Int, String)
error = ( 404, "msg not found")
print(error, error.0, error.1)
let (statusCode, statusMessage) = error
print(statusCode, statusMessage)
// OPTIONALS ///////////////////////////////////////////////////////////
// optionals indicate that a constant or variable is allowed to have “no value”.
let p = "12345"
let cp = Int(p)
print(cp)
if let a = Int("1234"){
    print(123)
}
else {
    print("not an int")
}

let rname: String? = nil
let rgreeting = "Hello, " + (rname ?? "friend") + "!"
print(rgreeting)

// force unwrapping
let possibleNumber = "123"
let convertedNumber = Int(possibleNumber)


let nnumber = convertedNumber!


guard let nnumber = convertedNumber else {
    fatalError("The number was invalid")
}
var possiblestuff : Int?
possiblestuff = Int("3423")
print(possiblestuff)

let opposites : [String? : String] = [
    "Mario": "Wario",
    "Luigi": "Waluigi"
]

let peachOpposite = opposites["Peach"]
print(peachOpposite)

print(("blue", 1) < ("purple", -1)    )

let range = ...5
range.contains(7)   // false
range.contains(4)   // true
range.contains(-1)  // true

//CLOSURES /////////////////////////////////////////////////////////////

