//
//  PlayerView.swift
//  Phase_3
//
//  Created by neermita.bhattacharya@wbd.com on 24/08/26.
//

import SwiftUI

struct PlayerView: View {
    @ObservedObject var interactor: PlayerInteractor
    @ObservedObject var castViewModel: CastViewModel
    @Environment(\.dismiss) private var dismiss

    @State private var scrubValue: Double = 0
    @State private var isScrubbing = false
    
    private var isConnected: Bool {
            if case .connected = castViewModel.state { return true }
            return false
        }
    
    var body: some View {
        ZStack {
            Color(white: 0.25).ignoresSafeArea()
            switch interactor.viewState {
            case .idle, .loading:
                ProgressView().tint(.white)
            case .failed(let msg):
                Text(msg).foregroundColor(.red)
            case .loaded(let data):
                content(data)
            }
        }
        .onAppear { interactor.start() }
        .onDisappear { interactor.stop() }
    }

    @ViewBuilder
    private func content(_ data: PlayerViewData) -> some View {
        VStack {
            HStack {
                Button { dismiss() } label: {
                    Image(systemName: "chevron.down").font(.title2).foregroundColor(.white)
                }
                .accessibilityLabel("Close player")
                Button { castViewModel.debugSimulateDeviceLost() } label: {
                    Image(systemName: "wifi.slash").font(.title2).foregroundColor(.white)
                }
                .accessibilityLabel("Simulate device lost")
               
                Spacer()
                // VOD <-> Live/DVR toggle
                Picker("", selection: Binding(
                    get: { data.isLive },
                    set: { _ in interactor.toggleStreamType() }
                )) {
                    Text("VOD").tag(false)
                    Text("Live/DVR").tag(true)
                }
                .pickerStyle(.segmented)
                .frame(width: 200)
                .accessibilityElement(children: .ignore)
                .accessibilityLabel("Stream mode")
                .accessibilityValue(data.isLive ? "Live and DVR" : "Video on demand")
                .accessibilityHint("Double tap to switch mode")
                .accessibilityAddTraits(.isButton)
            }
            .padding()

            Spacer()

            if isConnected, let url = data.artworkURL {
                AsyncImage(url: url) { image in
                    image.resizable().scaledToFit()
                } placeholder: {
                    Color.gray.opacity(0.2)
                }
                .frame(maxHeight: 320)
                .cornerRadius(12)
                .padding(.horizontal)
            }

            Spacer()

            // ----- Transport bar -----
            VStack(spacing: 12) {
                Slider(value: $scrubValue, in: 0...1) { editing in
                    isScrubbing = editing
                    if !editing { interactor.seek(toFraction: scrubValue) }
                }
                .tint(Theme.Palette.primaryText)
                .accessibilityLabel("Playback position")
                .accessibilityValue("\(data.currentTimeLabel) of \(data.trailingLabel)")
                .accessibilityHint("Swipe up or down to scrub")

                HStack {
                    Text(data.currentTimeLabel)
                    Spacer()
                    Text(data.trailingLabel)
                        .foregroundColor(data.isLive && data.isAtLiveEdge ? .red : .white)
                }
                .font(.caption.monospacedDigit())
                .foregroundColor(.white)

                HStack(spacing: 44) {
                    Button { interactor.skipBackward() } label: {
                        Image(systemName: "gobackward.10")
                    }
                    .accessibilityLabel("Skip back 10 seconds")

                    Button { interactor.togglePlayPause() } label: {
                        Image(systemName: data.isPlaying ? "pause.fill" : "play.fill")
                            .font(.system(size: 44))
                    }
                    .accessibilityLabel(data.isPlaying ? "Pause" : "Play")

                    if data.isLive {
                        Button { interactor.goToLive() } label: { Text("LIVE") /* … */ }
                            .disabled(data.isAtLiveEdge)
                            .accessibilityLabel("Jump to live")
                            .accessibilityHint(data.isAtLiveEdge ? "Already at live edge" : "Skips to the live broadcast")
                    } else {
                        Button { interactor.skipForward() } label: {
                            Image(systemName: "goforward.10")
                        }
                        .accessibilityLabel("Skip forward 10 seconds")
                    }
                }
                .font(.title)
                .foregroundColor(.white)
            }
            .padding()
        }
        // Keep the slider in sync with the ticking timer — but not while dragging.
        // Keep the slider in sync with the ticking timer — but not while dragging.
        .onChange(of: data.progress) { _, newValue in
            if !isScrubbing { scrubValue = newValue }
        }
        // Show a "Reconnecting…" cover while the device is being recovered.
        .overlay {
            if case .reconnecting(let device) = castViewModel.state {
                VStack(spacing: 16) {
                    ProgressView().tint(.white)
                    Text("Reconnecting to \(device.name)…")
                        .foregroundColor(.white)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.black.opacity(0.85))
                .accessibilityElement(children: .combine)
                .accessibilityLabel("Reconnecting to \(device.name)")
            }
        }
        // Device lost for good -> close the player so the picker (underneath) shows.
        .onChange(of: castViewModel.state) { _, newState in
            if case .disconnected = newState { dismiss() }
        }
    }
    
}
