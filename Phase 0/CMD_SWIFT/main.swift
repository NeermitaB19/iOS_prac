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
print("---------------- FUNCTIONS -----------------------")
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
print("---------------- DATA TYPES -----------------------")
var someName="Neermita"
print(someName.uppercased())
print(someName.count)
print(someName.hasPrefix("N"))
let num = 10203324325
print("Is \(num) a mutiple of 3: ",num.isMultiple(of: 3))

// ARRAYS /////////////////////////////////////////////////////////////////
print("---------------- ARRAYS -----------------------")
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
print("---------------- DICTIONARIES -----------------------")
let employee2 = ["name": "Taylor Swift", "job": "Singer", "location": "Nashville"]
var namesOfIntegers: [Int: String] = [:]
print(employee2["name"])
print(employee2["idkey"])
print(employee2["name", default:"Unknown"])
print(employee2["idkey", default:"Unknown"])


var height = [String: Int]()
height["Taylor"] = 180
print(height.count)
print(height.removeAll())


var airports = ["London": "Heathrow", "New York": "John F. Kennedy", "San Francisco": "San Francisco International"]


for airportCode in airports.keys {
    print("Airport code: \(airportCode)")
}
// Airport code: LHR
// Airport code: YYZ


for airportName in airports.values {
    print("Airport name: \(airportName)")
}




// SETS ///////////////////////////////////////////////////////////////////
print("---------------- SETS -----------------------")
let people = Set(["Denzel Washington", "Tom Cruise", "Nicolas Cage", "Samuel L Jackson"])
print(people)

var peoples = Set<String>()
var favoriteGenres: Set<String>=[]

peoples.insert("Denzel Washington")
peoples.insert("Tom Cruise")
print(peoples.count)
print(peoples.contains("Denzel Washington"))
print(peoples.sorted())
let houseAnimals: Set = ["🐶", "🐱"]
let farmAnimals: Set = ["🐮", "🐔", "🐑", "🐶", "🐱"]
let cityAnimals: Set = ["🐦", "🐭"]


print(houseAnimals.isSubset(of: farmAnimals))
// true
print(farmAnimals.isSuperset(of: houseAnimals))
// true
print(farmAnimals.isDisjoint(with: cityAnimals))

// TYPE ANNOTATIONS /////////////////////////////////////////////////////
print("---------------- TYPE ANNOTATIONS -----------------------")
let surname: String = "Lasso"
var score: Int = 0
var isStudent: Bool = true
var album: [String] = ["Red", "Fearless"]
var user: [String: String] = ["id": "@twostraws"]
print(user)
//type inference
var clues = [String]()
//type annotation
var cities: [String] = []

enum UIStyle {
    case light, dark, system
}

var style = UIStyle.light
print(style)
let username: String
username = "@nemo"

enum Weather {
    case sun, rain, wind, snow, unknown
}
// IF-ELSE & SWITCH CASE //////////////////////////////////////////////////////////
print("---------------- CONTROL -----------------------")
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
print("---------------- LOOPS -----------------------")
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
print("---------------- OPTIONALS -----------------------")
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
// The Swift logical operators && and || are left-associative, meaning that compound expressions with multiple logical operators evaluate the leftmost subexpression first.
let catCharacters: [Character] = ["C", "a", "t", "!", "🐱"]
let catString = String(catCharacters)
print(catString)

let ngreeting = "Guten Tag!"
print(ngreeting.count)
print(ngreeting[rgreeting.startIndex])
print(ngreeting[ngreeting.index(before: ngreeting.endIndex)]
)
var welcome = "hello"
welcome.insert("!", at: welcome.endIndex)
// welcome now equals "hello!"


welcome.insert(contentsOf: " there", at: welcome.index(before: welcome.endIndex))
print(welcome)
///////////////////////////////////////unwrap optionals using guard
func printSquare(of number: Int?) {
    guard let number = number else {
        print("Missing input")
        return
    }

    print("\(number) x \(number) is \(number * number)")
}

printSquare(of:nil)
printSquare(of:89987)


struct Book {
    let title: String
    let author: String?
}

var book: Book? = nil
let author = book?.author?.first?.uppercased() ?? "A"
print(author)

func op (_ ar : [Int]?) -> Int{
    let value = ar?.randomElement() ?? Int.random(in: 1...100)
    return value
}
print("FINAL OPTIONALS PRACTICE: ", op([3,6,3,564,46,326,7,34,547,548]))
// DEFER ////////////////////////////////////////////////////////////////
print("---------------- DEFER -----------------------")
var sscore = 1
if score < 15 {
    defer {
        print(sscore)
    }
    sscore += 5
}
// it prints after the if block is done




//CLOSURES /////////////////////////////////////////////////////////////
print("---------------- CLOSURES -----------------------")
// they can be functions with no params and no return values
//copying a function : var variable = function (this is copy of a function)
//variable()
/* not var variable = function()
 */

let sayHello = {
    print("Hi there!")
}

sayHello()

//we could accept params too tho
let sayHello2 = {(name: String) -> String in
    "Hi \(name)!"
    
    
}
print(sayHello2("Nemo")) //no need for external params

//normal function :
struct Student{
    var name : String
    var testScore : Int
}
func topStudentFilterF(_ student : Student) -> (Bool) {
    return student.testScore > 80
}

var newStudent = Student(name: "Nemo", testScore: 89)
print("Student is a topper: ",topStudentFilterF(newStudent))
//closure
var topStudentFilter : (Student) -> (Bool) = { student in
    return student.testScore > 80
}
var newTopFilter : (Student) -> (Bool) = {
    $0.testScore > 80
    
}

print("Student is a topper: ",topStudentFilter(newStudent))



print("---------------------STRUCTS------------------------")
struct newEmployee {
    let name : String
    var vacationAllocated : Int
    var vacationTaken = 0
//    mutating func calc(){
//        vacationRemaining = vacationAllocated - vacationTaken
//    }
    
    var vacationRemaining : Int{
        get{
            vacationAllocated - vacationTaken
        }
        set(newValue) {
            vacationAllocated = vacationTaken + newValue
        }
    }
}
var emp2 = newEmployee(name: "Neermita", vacationAllocated: 34)
print(emp2.vacationRemaining)
emp2.vacationTaken = 10
print(emp2.vacationRemaining)
emp2.vacationRemaining = 5
print(emp2.vacationRemaining)
print(emp2.vacationTaken)
print(emp2.vacationAllocated)

struct App {
    var contacts = [String]() {
        willSet {
            print("Current value is: \(contacts)")
            print("New value will be: \(newValue)")
        }

        didSet {
            print("There are now \(contacts.count) contacts.")
            print("Old value was \(oldValue)")
        }
    }
}

var app = App()
app.contacts.append("Adrian E")
app.contacts.append("Allen W")
app.contacts.append("Ish S")
struct Game {
    var score = 0 {
        didSet {
            print("Score is now \(score)")
        }
    }
}

var game = Game()
game.score += 10
game.score -= 3
game.score += 1

struct Player {
    let name: String
    let number: Int

    init(name: String, number: Int) {
        self.name = name
        self.number = number
    }
}




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
