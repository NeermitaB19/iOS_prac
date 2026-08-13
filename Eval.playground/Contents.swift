import Cocoa

var greeting = "Hello, playground"
import Combine


//MARK: question 1 :
// array1 will remain unchanged (value type)
// classArray will change because its reference to the object

// MARK: question 2:
// type annotation is user - its a dictionary of strings
// type inference is cities - it infers its an array of strings (initialized)

//MARK: question 3
// ! is forced unwrapping - we use it when we're sure there's a value
let possibleNumber = "123"
let convertedNumber = Int(possibleNumber)
if let cn = convertedNumber{
    print(cn)
}
else{
    print("cant")
}
func guards(){
    guard let cnn = convertedNumber else {
        return print("cant")
    }
    print(cnn)
}
guards()
let cnnn = convertedNumber ?? 1

// MARK:  question 4
let ngreeting = "Guten Tag!"
print(ngreeting.count)
print(ngreeting[ngreeting.startIndex])
var welcome = "hello"
welcome.insert("!", at: welcome.endIndex)
let exclamationIndex = welcome.firstIndex(of: "!")!
welcome.insert(contentsOf: " there", at: exclamationIndex)
print(welcome)



// MARK: question 5

enum NetworkError: Error {
    case noInternetConnection
    case timedOut
    case invalidResponse
    case illegalTransition
    
}
enum CastDevice {
    case tv
    case projector
}
enum ConnectionState {
    case disconnected
    case discovering
    case connecting(CastDevice)
    case connected(CastDevice)
    case reconnecting
    case failed(NetworkError)
}

func extract(cn: ConnectionState)->(CastDevice?){
    if case let ConnectionState.connecting(d) = cn{
        return d
    }
    else{
        return nil
    }
}

//MARK: question 6
struct Student{
    let testScore : Int
}
var topStudentFilter : (Student) -> (Bool) = { student in
return student.testScore > 80
}
// this closure  is the general way to write closures. the second one is shorthand syntax and returns the same thing

// $0 represents the first param (student)

// MARK: question 7

// willset and didset observe data. it can be used to know the oldvalues or newvalues and take decisions based on them. or make filters for bad values
var name2: String = "Unknown" {
willSet {
print("\(name2) will change to \(newValue)")
}
didSet {
name2 = name2.capitalized
print("Name changed from \(oldValue) to \(name2)")
}
}

// first, name will change from unknown to jjohn
// but didset has capitalization in it. so the oldvalue is unknown but newvalue is Jjohn

// MARK: Question 8

func swap<T>(a: inout T, b: inout T) {
    var temp = a
    a = b
    b = temp
    }
struct Stack<T> {
    var items: [T]
    mutating func push(item: T) {
    items.append(item)
    }
    mutating func pop() -> T {
    items.removeLast()
    }
}

func findLargest<T: Comparable>(arr : [T])->(T){
    var a = arr.sorted()
    return arr[arr.endIndex - 1] as! T
}
print(findLargest(arr: [4,6,3,6,24,7,243]))

//MARK: question 9
// reconnecting needs a value (which device to connect to)
// if the enum connection state had an associated value in the definition, then it'll throw an error

// fix by using reconnecting(_)

// MARK: question 10

func err(cn : ConnectionState){
    let state = cn
    if case .failed(let error) = state {
        print("Error occured: \(error)")
    }
    
    
}
err(cn: ConnectionState.failed(.noInternetConnection))


// MARK: Question 11

func validTransition(from: ConnectionState, to: ConnectionState) -> Bool {
    return true
}
func canTransition(from: ConnectionState, to: ConnectionState) -> Bool {
    if validTransition(from: ConnectionState.disconnected, to: ConnectionState.failed(NetworkError.invalidResponse)){
        return true
    }
    else{
        return false
    }
}

// MARK: Question 12
struct CastDevice2 {
let id: Int
let name: String
var type: CastDeviceType
}
enum CastDeviceType: String {
case tv
case speaker
case display
case group
}


class DeviceManager{
    init(){}
    
    var list = [CastDevice2]()
    
    func addDevice(device : CastDevice2){
        if !list.contains(where:{ existsdevice in existsdevice.id == device.id}){list.append(device)}
    }
    
    func findDevice(by id: Int) -> CastDevice2? {
        return list.first(where: { $0.id == id })
        
    }
    
    func fil(by type: CastDeviceType)->([CastDevice2])
    {
        return list.filter({d in d.type == type})
    }
    
}

//MARK: Question 13
enum Errors: Error {
    case divideByZero
}
enum Result<Success, Failure: Error> {
case success(Success)
case failure(Failure)
}
// vs modern approach
func divide(a: Int, b: Int) -> Result<Int, Error> {
if b == 0 {
return Result.failure(Errors.divideByZero)
}
return Result.success(a/b)
}

func divide2 (a : (Int), b : Int) async throws ->(Int)  {
    if b==0{
        throw Errors.divideByZero
    }
    else{
        return (a/b)
    }
    
}
func performDivisions() async {
    do {
        let result1 = try await divide(a: 100, b: 2)
        print("Result 1:", result1)
        
//                let result2 = try await divide(a: result1, b: 5)
        //        print("Result 2:", result2)
        //
        //        let result3 = try await divide(a: result2, b: 2)
        //        print("Result 3:", result3)
        //
        //        let result4 = try await divide(a: result3, b: 5)
        //        print("Result 4:", result4)
        //
        //        let result5 = try await divide(a: result4, b: 2)
        //        print("Result 5:", result5)
        //
        //    } catch Errors.divideByZero {
        //        print("Cannot divide by zero")
        //    } catch {
        //        print( error)
        //    }
    }
  
    // MARK: question 15
    //class ConnectionHandler {
    //var onConnected: ((CastDevice) -> Void)?
    //
    //func setupHandlers(device: CastDevice2) {
    //onConnected = {
    //// What's wrong here?
    //print("Connected to \(self.device.name)")
    //}
    //}
    //}
    // the closure has strong reference to the class and vice versa. it creates retain cycles.
    
    
    //class ConnectionHandler {
    //    init(){}
    //var onConnected: ((CastDevice) -> Void)?
    //func setupHandlers(device: CastDevice) {
    //onConnected = {
    //// What's wrong here?
    //[weak self] in print("Connected to \(self.device.name)")
    //}
    //}
    //}
    
    
    // MARK: question 16
    func fetchImages () async throws -> Int{
        print("images fetched")
        return 2
    }
    do{ let images = try await  fetchImages()
        print(images)
        
    }catch{
        print(error)
    }
    //MARK: Question 17
    // because we are telling to take the print statement and put in the main queue which will run on the main thread when available. but this is running on the main thread itself and wont continue until task is done (sync). they keep waiting for each other
    // DispatchQueue.main.async{}
    
    //use sync when i want the caller to not continue any other task while the current task executes.
    // use async for cases like network downloading
    
    
    // MARK: Question 19
    
    // overall will take 3 secs. for sequential await calls it'd take 5 secs. hence use async let for parallel tasks
    
    
    // MARK: Question 21
    
    //actors let only one update occur at atime (serially), thats why race condition can never happen
    actor BankAccount {
        var balance = 1000
        func withdraw(_ amount: Int) {
            balance -= amount
        }
    }
    let account = BankAccount()
    
    Task {
        await account.withdraw(100)
        print("bank acc: ", await account.balance)
    }
    
    Task {
        await account.withdraw(200)
    }
    
    Task {
        await account.withdraw(300)
    }
    
    Task {
        await account.withdraw(150)
    }
}

//MARK: Question 14

class ConnectionManager{
    var state : ConnectionState = ConnectionState.disconnected
    func connect(to device : CastDevice) async throws {
        
        
        guard validTransition(from: state, to: .discovering)else{
            throw NetworkError.illegalTransition
        }
        state = ConnectionState.discovering
        print("Discovering")
        try await Task.sleep(for: .seconds(5))
        guard validTransition(from: state, to: .connecting(.tv)) else{
            throw NetworkError.illegalTransition
        }
        state = .connecting(.tv)
        print("Connecting")
        try await Task.sleep(for: .seconds(5))
        
        guard validTransition(from: state, to: .connected(.tv)) else{
            throw NetworkError.illegalTransition
        }
        state = .connected(.tv)
        print("Connected!!!")
        
        
    }
    
}

var CM = ConnectionManager()
Task {
    do {
        try await CM.connect(to: CastDevice.projector)
    } catch {
        print("Connection failed:", error)
    }
}

//MARK: Question 18
let group = DispatchGroup()
group.enter()
DispatchQueue.global().async {
Thread.sleep(forTimeInterval: 1.5)
print("Subtitles finished")
group.leave()

}
group.enter()
DispatchQueue.global().async {
    Thread.sleep(forTimeInterval: 5.5)
    print("Video finished")
    group.leave()
}
group.enter()
DispatchQueue.global().async {
    Thread.sleep(forTimeInterval: 3.0)
    print("Audio finished")
    group.leave()
}
group.notify(queue: .main) {
print("All tasks complete")
}

//MARK: question 20
func fetchDescription(_ url: URL?) async throws -> String {
    if let url = url{
        return url.absoluteString
    }
    else{
        throw URLError(.badURL)
    }
    
}
func downloadAllDesc(urls: [URL]) async throws -> [String] {
        return try await withThrowingTaskGroup(of: String.self) { group in
        for url in urls {
        group.addTask {
            do
                {
                    return try await fetchDescription(url)
                }
            catch
                {
                    return "failed : \(error)"
                }
            }
        }
        var descriptions: [String] = []
        for try await desc in group {
                descriptions.append(desc)
            }
        return descriptions
            }
        }


//MARK: question 22

func fetchData()->(Int){
    return 45
}
@MainActor
func updateUI(){
    print("I'm on main actor rn")
}
Task.detached{
    var im = fetchData()
    print("collected \(im) images")
    await MainActor.run{
        print("back to UI")
    }
}

updateUI()

//MARK: question 24
func pingGoogle () async throws -> (Data)
    {
        guard let url = URL(string: "https://www.google.com") else
        {
            throw URLError(.badURL)
            
        }
        var req = URLRequest(url: url)
        req.setValue("Bearer 12345", forHTTPHeaderField: "Authorization")
            
        let (data, response) = try await URLSession.shared.data(for: req)
            
        return data
    }

Task {
    do
        {
          let url = try await pingGoogle()
            print("this worked !! Data: ",url)
            
        }

    catch
        {
         print(error)
        }

}

//MARK: question 25
// no throwing:

func connectToChromecast(ip: String, completion: @escaping (Bool) -> Void) {
    
}
func newConnect(ip: String) async -> Bool {
    return try await withCheckedContinuation { continuation in
        connectToChromecast(ip: ip) { success in
            
    continuation.resume(returning: success)
            
        }
    }
}
// with result
//func connect(completion: @escaping (Result<Bool, Error>) -> Void) {
//    
//}
//func resultConnect() async -> Result<Bool, Error> {
//    return await withCheckedContinuation { continuation in
//        
//        connect() { result in
//            continuation.resume(returning: result)
//        }
//    }
//}
//let result = await resultConnect()
//switch result{
//case .success:
//    print("connected")
//case .failure:
//    print("error")
//}

//MARK: question 27

//Passthrpughsubject doesnt remember last value. it will get value only once its subscribed - use for one time events like otp, or button taps
//Currentvaluesubject remembers latest values and has initial value - use to remember state

//MARK: question 28
let numbers = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]

var publisher = CurrentValueSubject<Int, Never>(0)
let subs = publisher.filter{number in number % 2==0

}.map{
    number in
        number*2
}.filter{
    value in
        value > 10
}.sink{
    value in
        print("received: ", value)
}

for n in numbers{
    publisher.send(n)
}

// MARK: question 29
//  StreamingPLayer -> onPlay (self) -> StreamingPLayer -> onPlay
//StreamingPLayer strongly owns closure whihc strongly captures self (StreamingPlayer)
// weak self tells to capture self but not strongly
// StreamingPlayer -> strong -> onPlay -> weak -> StreamingPlayer
