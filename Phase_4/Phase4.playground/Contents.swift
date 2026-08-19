import Cocoa

var greeting = "Hello, playground"

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

