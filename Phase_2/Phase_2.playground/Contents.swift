import UIKit

var greeting = "Hello, playground"


// MARK: ASYNC and AWAIT

func fetchImages() async throws -> [String]{
    return []
}

// previously completion handlers were used :
// func fetch(completion: @escaping ([UIImage]) -> Void){}
//// func fetchImages(
//completion: (Result<[UIImage], Error>) -> Void
//)


//fetchImages { result in
//    // 3. The asynchronous method returns
//    switch result {
//    case .success(let images):
//        print("Fetched \(images.count) images.")
//    case .failure(let error):
//        print("Fetching images failed with error \(error)")
//    }
//}


Task{
    do {
        let images = try await fetchImages()
        print("Fetched \(images.count) images.")
    } catch {
        print("Fetching images failed with error \(error)")
    }
}


// MARK: ARC and Memory Leaks
class StreamingPlayer {
    var title = "HBO Stream"
    var onPlay: (() -> Void)?

//    func setupPlayer() {
//        // THE TRAP:
//        // 1. StreamingPlayer owns the 'onPlay' closure.
//        // 2. The closure uses 'self.title', so it captures 'self' (the StreamingPlayer).
//        // Result: Infinite loop. Memory leak.
//        onPlay = {
//            print("Playing \(self.title)")
//        }
//    }
    
    func setupPlayer() {
        onPlay = { [weak self] in
            // We must check if 'self' still exists before using it
            guard let self = self else {
                print("Player was destroyed before we could play.")
                return
            }
            print("Playing \(self.title)")
        }
    }
}

var sp = StreamingPlayer()
// use init to pass params
sp.setupPlayer()
sp.onPlay?()


var sp2: StreamingPlayer? = StreamingPlayer()
sp2?.setupPlayer()

let closure = sp2!.onPlay

sp2 = nil        // Player is deallocated

closure?()


// MARK: QUEUES AND GROUPS


import Foundation
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true

// MARK: - 1. DispatchQueue
print("--- Starting DispatchQueue Example ---")
print("1. UI is loading...")

//background
DispatchQueue.global(qos: .userInitiated).async {
    print("2. [Background Thread] Downloading heavy file...")
    
    // Simulate taking 2 seconds to download
    Thread.sleep(forTimeInterval: 2.0)
    
    let downloadedData = "HBO Max Video Data"
    print("3. [Background Thread] Download complete!")
    
    // Route back to the Main Thread to update the UI
    DispatchQueue.main.async {
        print("4. [Main Thread] Updating UI with: \(downloadedData)")
        print("--------------------------------------\n")
       
        runDispatchGroupExample()
    }
}

// MARK: - 2. DispatchGroup
func runDispatchGroupExample() {
    print("--- Starting DispatchGroup Example ---")
    
    let group = DispatchGroup()
    
    // Simulate Request 1: Subtitles
    group.enter()
    print("Starting Subtitles download...")
    DispatchQueue.global().async {
        Thread.sleep(forTimeInterval: 1.5) // Takes 1.5 seconds
        print("Subtitles finished")
        group.leave()
    }
    
    // Simulate Request 2: Video Stream
    group.enter()
    print("Starting Video Stream download...")
    DispatchQueue.global().async {
        Thread.sleep(forTimeInterval: 3.0) // Takes 3 seconds
        print("Video Stream finished!")
        group.leave()
    }
    
    // Simulate Request 3: Audio Track
    group.enter()
    print("Starting Audio Track download...")
    DispatchQueue.global().async {
        Thread.sleep(forTimeInterval: 1.0) // Takes 1 second
        print(" Audio Track finished!")
        group.leave()
    }
    
    // This will only trigger when ALL 3 group.leave() calls have been made
    group.notify(queue: .main) {
        print("\nThe movie is ready to play.")
        
        
        PlaygroundPage.current.finishExecution()
    }
}


// MARK: DEADLOCK
//DispatchQueue.main.sync {
//    print("This blocks the main thread from executing this very block.")
//}

//MARK: ASYNC LET and TASKGROUP

//async let when u know number of tasks
func fetchDescription(_ url : URL) async throws -> String {
    try await Task.sleep(nanoseconds:(3000000000))
    return "This is an asynchronous description."
}
func fetchPoster() async throws -> Data {
    try await Task.sleep(nanoseconds: (2000000000))
    return Data(count: 100_000)
}

func fetchMoviePage() async throws -> (String, Data){
    let url : URL = URL(string: "https://www.google.com")!
    async let descp = fetchDescription(url)
    async let poster = fetchPoster()
    
    return try await (descp, poster)
}


Task {
    do {
        let page = try await fetchMoviePage()
        print(page)
    } catch {
        print(error)
    }
}

// taskgroup when unknown quantity of tasks
func downloadAllDesc(urls : [URL]) async throws -> [String] {
    return try await withThrowingTaskGroup(of: String.self) { group in
        for url in urls {
            
            // adds a concurrent task to the group for every url
            
            group.addTask{
                return try await fetchDescription(url)
            }
        }
        var descriptions : [String] = []
        for try await desc in group {
            descriptions.append(desc)
        }
        return descriptions
    }
}
Task {
    do {
        var desc = try await downloadAllDesc(urls: [URL(string: "https://www.google.com")!])
        
        print("This is in TaskGroup function: ", desc)
    }
    catch {
        print(error)
    }
}


// MARK: Task detached
@MainActor
func test() {
    print("I'm on the Main Actor")
}

test()

Task.detached {

    print("Detached task")

    await MainActor.run {
        print("Now I'm on the Main Actor")
    }
}

class Thing {
    init()
    {
        
    }
    func printAsync(_ string : String) async {
        print(string)
    }
    
    func go () async {
        await self.printAsync("Thing 1 ")
        Task.detached(priority: .background){
            await self.printAsync("Thing 2 ")
        }
        await self.printAsync("Thing 3 ")
    }
}
let thing = Thing()
Task{
    await thing.go()
}
// MARK: Actors
// they are reference types, and has a built in lock
// to avoid race conditions, priority inversions, deadlocks

actor BankAccount {

    var balance = 1000

    func withdraw(_ amount: Int) {
        balance -= amount
    }
}
Task {
    let account = BankAccount()
    await account.withdraw(100)
    await print(account.balance)
    await account.withdraw(200)
    await print(account.balance)
}
