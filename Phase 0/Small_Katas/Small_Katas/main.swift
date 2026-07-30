//
//  main.swift
//  Small_Katas
//
//  Created by neermita.bhattacharya@wbd.com on 28/07/26.
//
print("---------------------Timer--------------------")
import Foundation

func clock(_ time: Int) -> String {
    let min = (time/60)
    let sec = (time%60)
    return String(format: "%02d:%02d", min, sec)
}

print(clock(145))


print("---------------------Closures--------------------")
var square : (Int) -> (Int) = {sq in
    return sq*sq}
print(square(789))

var square2 = {
    (sq : Int) -> (Int) in
    return sq*sq
}
print(square2(789))

let numbers = [13, 453, 576, 6786,4, 4789]
let sortedNumbers : ([Int]) -> ([Int]) = {numbers in
    return numbers.sorted()}
print(sortedNumbers(numbers))

let reversedNums = numbers.sorted(by: {(s1 : Int, s2: Int) -> (Bool) in
    return s1 > s2
})
print(reversedNums)

func cl(num:Int, closure : (Int) -> (Int)) -> (Bool){
    if closure(num) == 0{
        return true
    }
    else {
        return false
    }
}
let newcl = {(number : Int) -> (Int) in
return number%11 }

print(cl(num: 696769679, closure: newcl))



var savedClosure : (() -> Void)?
func saveClosure(_ closure : @escaping () -> Void){
    print("Inside saveClosure")
        savedClosure = closure
        print("Leaving saveClosure")
    }

saveClosure({print("saved closure")})

print("---------------------Structs--------------------")
struct Employee{
    let name : String
    var vacationRemaining : Int
    
    mutating func takeVacation(days : Int){
        if vacationRemaining > days{
            vacationRemaining = vacationRemaining - days
            print("I have , \(vacationRemaining) days to enjoy only")
        }
        else{
            print("Oh no, i dont have any more vacation days")
        }
    }
    
}

var emp1 = Employee(name : "Nemo", vacationRemaining: 67)
emp1.takeVacation(days: 10)
emp1.takeVacation(days: 11)

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
