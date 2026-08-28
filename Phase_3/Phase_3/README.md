# FauxCast

A small, SDK-free iOS app that reproduces the *shape* of the Chromecast sender
experience end to end: **discover fake devices → connect → mini player →
expanded player with transport controls → handle disconnect** — all driven by a
hand-built `FakeCastEngine`.

There is **no Google Cast SDK, no `wbd-beam-swift` dependency, and no real
network**. Everything Cast-like is simulated so the focus stays on the
architecture and the mental model, not SDK plumbing.

> This is the Phase 8 of the CAST iOS onboarding path. Phases 4–7
> built the mini player, the expanded player, the tests, and the production
> polish; this README ties them together and maps them onto the real
> `ChromecastFeature` module.

---

## Running it

1. Open `Phase_3.xcodeproj` in Xcode.
2. Select an iPhone simulator and press ▶.
3. Tests: `⌘U` (unit + snapshot tests live in `Phase_3Tests`).

The one external dependency is [`swift-snapshot-testing`](https://github.com/pointfreeco/swift-snapshot-testing),
linked to the **test target only**. The app itself ships zero third-party code.

---

## The one mental model

The Chromecast sender is a **remote control, not screen mirroring**. The phone
tells a receiver *what* to play and *how* to seek; the receiver plays
independently. FauxCast keeps that shape: the "receiver" is the
`FakeCastEngine`, whose `RemoteMediaState` advances on a timer as if a TV were
playing on its own. The UI only ever *reflects* that state and *sends commands*
to it.

## Architecture

One spine runs through the whole app:

```
FakeCastEngine  →  Interactor  →  ViewState<T>  →  dumb SwiftUI View
 (fake receiver)   (business      (idle/loading/    (renders state,
                    logic)         loaded/failed)     forwards taps)
```

- **`FakeCastEngine`** is the single source of truth. It exposes **Combine
  publishers** (read-only streams: devices, now-playing, remote media state,
  connection events) and **command methods** (`load`, `toggleRemotePlayPause`,
  `seekRemote`, `skipRemote`, `goToLive`, `setStreamType`).
- **Interactors** subscribe to publishers, transform raw values into a
  `ViewState`, and turn user actions into engine commands. They depend on the
  **`PlaybackEngine` protocol**, not the concrete engine — that's the seam that
  makes them testable.
- **`ViewState<T>`** models every screen as one observable enum
  (`idle / loading / loaded(T) / failed`).
- **Views are "dumb"**: they `switch` over `viewState` and call interactor
  methods. No business logic lives in the view.

### File map

| Area | Files | Role |
| --- | --- | --- |
| Fake receiver | `FakeCastEngine.swift`, `PlaybackEngine.swift` | Simulated Cast engine + the protocol seam for DI/testing |
| Domain models | `Models.swift` | `CastDevice`, `ConnectionState`, `RemoteMediaState`, `NowPlayingItem`, `StreamType`, `CastConnectionEvent` |
| Connection state machine | `CastViewModel.swift` | Discovery, connect/disconnect, reconnect, persistence, picker presentation |
| Device picker | `CastSheetView.swift` | "Cast to…" sheet reflecting connection state |
| Mini player | `MiniPlayerInteractor.swift`, `MiniPlayerBar.swift` | Now-playing bar; play/pause bound to shared remote state |
| Expanded player | `PlayerInteractor.swift`, `PlayerView.swift` | Transport bar: scrubber, times, play/pause, skip ±10s, VOD↔Live toggle |
| Shared UI state | `ViewState.swift` | The generic view-state enum |
| Design tokens | `Theme.swift` | Colors / spacing / radius / sizes (no magic numbers) |
| Composition | `ContentView.swift` | Wires one shared engine into both interactors; hosts mini + expanded player; `PlayerDetailView` |
| Content browsing | `HomeViewModel.swift`, `TMDBService.swift` | Poster grid (the thing you tap to start "casting") |
| Tests | `Phase_3Tests/…` | State-machine, interactor, and snapshot tests + `MockPlaybackEngine` |

### Key design decisions

- **One shared engine.** `ContentView.init()` creates a single `FakeCastEngine`
  and injects it into both the mini and expanded interactors, so play/pause and
  now-playing stay in sync across both surfaces.
- **Single playback truth.** "Is playing" always comes from
  `remoteStatePublisher`, never a private flag — the mini bar and full player
  can never disagree.
- **Value-type state.** `RemoteMediaState` is a struct pushed through a
  `CurrentValueSubject`; each timer tick copies-mutates-sends, which keeps
  progress evolution predictable.
- **Protocol-based DI.** Interactors take `PlaybackEngine`, so tests inject
  `MockPlaybackEngine` and *pump* publisher values deterministically (no real
  timers in tests).

## Feature walkthrough (happy path)

1. **Browse** posters (`ContentView` / `HomeViewModel`).
2. **Cast** — tap the cast button → `CastSheetView` lists fake devices emitted
   by discovery → tap one → `ConnectionState` runs
   `discovering → connecting → connected`.
3. **Mini player** appears when media loads (`MiniPlayerBar`), showing
   title/subtitle/artwork and a play/pause bound to remote state.
4. **Expanded player** — tap the mini bar → `PlayerView` with a live scrubber,
   current/total time, play/pause, skip ±10s, and a **VOD ↔ Live/DVR** toggle
   that changes which controls appear (VOD = skip-forward; Live = a "LIVE"
   button + a moving 30-min DVR window).
5. **Disconnect / recover** — losing a device drives
   `connected → reconnecting → (reconnected | disconnected → picker)`.

---

## How this maps onto the real `ChromecastFeature`

The production sender lives in **`wbd-beam-swift`**, split across three layers:
`apps/Fuse/Features/ChromecastFeature/` (UI), `ThunderPlayer/Cast/` (session
coordination), and `PlayerCore/Cast/` (the GCK wrapper). FauxCast collapses
those into one `FakeCastEngine`, but the responsibilities line up cleanly.

### Concept mapping

| FauxCast | Real `wbd-beam-swift` | Notes |
| --- | --- | --- |
| `FakeCastEngine` (publishers + commands) | `CastSenderController` (ThunderPlayer) + `Chromecast.swift` + `CastPlayer.swift` (PlayerCore) | Our one class stands in for the public sender API, the GCK wrapper, and the remote player |
| `startDiscovery()` / `devicesSubject` | `CastDeviceDiscoveryManager.startDiscovery()` over `GCKDiscoveryManager`; devices published by `CastSessionControls` | Real discovery starts after the first Cast-button tap |
| `ConnectionState` enum + `CastViewModel` transitions | GCK session lifecycle (`sessionWillStart/DidStart/DidEnd`) surfaced via `CastSessionStateListener` → `CastState`, published by `CastSessionControls.castStatePublisher()` | Same "model the lifecycle explicitly" habit |
| `CastSheetView` (device picker) | `ChromecastFeature` device-list UI (Cast button, connecting/connected states) | Same UI-reflects-state principle |
| `MiniPlayerInteractor` + `MiniPlayerBar` | `CastMiniPlayerInteractor` + its view in `ChromecastFeature` | Interactor-drives-dumb-view is exactly the team pattern |
| `PlayerInteractor` + `PlayerView` (transport bar) | `ChromecastFeature` full cast player + `CastPlayerControlsComponent` (ThunderPlayer) mapping remote state → events | Progress/scrub/skip/VOD-vs-Live all live here in prod too |
| `remoteStatePublisher` / `RemoteMediaState` | `RemotePlayerStateListener` → `CastMediaState`; progress from `CastReceiverEventObserver` | Receiver is the source of truth; sender reflects it |
| `loadMedia(NowPlayingItem)` | `CastSenderController.load(...)` → `CastPlayer.load` → `CastMediaLoader` builds `GCKMediaInformation` → `GCKRemoteMediaClient.loadMedia` | We send a struct; prod sends a content ID + token + custom data |
| `toggleRemotePlayPause` / `seekRemote` / `skipRemote` | `play()` / `pause()` / `seek()` on `CastPlayer` → `GCKRemoteMediaClient` | Prod adds a 300ms seek debounce + background retry queue |
| `StreamType` VOD vs `liveDVR` + `dvrWindow` | `mainStartingPosition` (`LIVE_EDGE` / `START_OVER` / VOD ms) + `getLiveSeekableRange()` moving window | Same VOD-vs-live modelling, minus real timelines |
| `connectionEvents` + reconnect flow | `playbackRoutePublisher` (`.internal` / `.chromecast(id)`) + `CastSenderLifecycleCoordinator` background/resume | Prod rule: trust the playback route, not raw GCK connection state |
| `PlaybackEngine` protocol (DI seam) | `PlayerBuilder.setCastSenderController(_:)` injection + `CastSenderPublisherFactory` bridging publishers into interactors | Same "inject the engine, bridge publishers to interactors" wiring |
| `Theme.swift` tokens | `AppUI` `colorTokens` / `textTokens` (or an injected `CastUIConfig`) | Both avoid hard-coded styling |
| `ViewState<T>` + dumb SwiftUI views | `ChromecastFeature` interactors + `DeclarativeUIKit` views | Same separation; prod view layer is DeclarativeUIKit, not SwiftUI |
| `Phase_3Tests` (unit) / `PlayerSnapshotTests` | `ChromecastFeatureTests` / `ChromecastFeatureSnapshotTests` (+ `ChromecastFeatureTestHelpers`, `MockPlaybackEngine` ≈ shared fakes) | Same Mock/Spy + snapshot conventions |

### What FauxCast intentionally leaves out

These exist in production but are **out of scope** here — worth naming in the
demo so the boundary is clear:

- The **GoogleCast SDK** (`GCKCastContext`, `GCKSessionManager`,
  `GCKRemoteMediaClient`) and a real receiver (`beam-cast-web-receiver`).
- **Custom message channels / namespaces** (`urn:x-cast:beam_*`) for track
  selection, skip intro/recap, and Up Next.
- **PIN / R21 load-interrupt**, **ads on cast**, **DRM/FairPlay**, and
  **audio/subtitle track** round-trips.
- **Local ↔ cast handoff** (`CastPlaybackCoordinator` pausing the local player)
  — FauxCast has no local `AVPlayer`.

### The takeaway

If you understand FauxCast's `Engine → Interactor → ViewState → View` loop, the
discovery/session/remote-media publishers, and the VOD-vs-live branching, then
`ChromecastFeature` is the same architecture with (a) the GCK SDK behind
`CastSenderController`/`CastPlayer` and (b) a real receiver as the source of
truth instead of a timer.

---

## Demo script (≈3 min)

1. **Frame it:** "Sender = remote control, not mirroring." Point at the timer in
   `FakeCastEngine.startRemotePlayback()` — that's the pretend receiver.
2. **Discover → connect:** open the picker, connect, narrate the
   `ConnectionState` transitions.
3. **Mini player:** show it appear on load; toggle play/pause and note it stays
   in sync with the expanded player (single remote-state truth).
4. **Expanded player:** scrub (seek), skip ±10s, then flip **VOD ↔ Live/DVR** and
   show how the controls change.
5. **Unhappy path:** simulate device lost → reconnecting → back to picker.
6. **Map to prod:** point at the mapping table — "`FakeCastEngine` is
   `CastSenderController` + `CastPlayer`; this interactor is
   `CastMiniPlayerInteractor`; the receiver here is a timer."
