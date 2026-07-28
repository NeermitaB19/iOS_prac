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

//CLOSURES /////////////////////////////////////////////////////////////
