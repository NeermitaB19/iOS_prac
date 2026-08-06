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

// MARK: - 1. DispatchQueue Example
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

// MARK: - 2. DispatchGroup Example
func runDispatchGroupExample() {
    print("--- Starting DispatchGroup Example ---")
    
    let group = DispatchGroup()
    
    // Simulate Request 1: Subtitles
    group.enter() // Tell group we are starting
    print("Starting Subtitles download...")
    DispatchQueue.global().async {
        Thread.sleep(forTimeInterval: 1.5) // Takes 1.5 seconds
        print("Subtitles finished")
        group.leave() // Tell group we are done
    }
    
    // Simulate Request 2: Video Stream
    group.enter() // Tell group we are starting
    print("Starting Video Stream download...")
    DispatchQueue.global().async {
        Thread.sleep(forTimeInterval: 3.0) // Takes 3 seconds
        print("Video Stream finished!")
        group.leave() // Tell group we are done
    }
    
    // Simulate Request 3: Audio Track
    group.enter() // Tell group we are starting
    print("Starting Audio Track download...")
    DispatchQueue.global().async {
        Thread.sleep(forTimeInterval: 1.0) // Takes 1 second
        print(" Audio Track finished!")
        group.leave() // Tell group we are done
    }
    
    // This will only trigger when ALL 3 group.leave() calls have been made
    group.notify(queue: .main) {
        print("\nThe movie is ready to play.")
        
        // Optional: End the playground execution cleanly
        PlaygroundPage.current.finishExecution()
    }
}
