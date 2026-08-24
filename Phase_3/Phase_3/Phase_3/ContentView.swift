import SwiftUI
import Combine
import AVKit
// MARK: - Reusable horizontal poster row
struct MediaRow: View {
    let title: String
    let items: [MediaItem]
    let viewModel: CastViewModel
    let onSelect: (MediaItem) -> Void
    
    var body: some View {
        if !items.isEmpty {
            VStack(alignment: .leading, spacing: 8) {
                Text(title)
                    .font(.title2).bold()
                    .foregroundColor(.white)
                    .padding(.horizontal)
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 15) {
                        ForEach(items) { item in
                            NavigationLink(destination: PlayerDetailView(media: item, viewModel: viewModel)) {
                                VStack(alignment: .leading) {
                                    Color.clear
                                        .frame(width: 130, height: 195)
                                        .overlay {
                                            AsyncImage(url: item.posterURL) { image in
                                                image.resizable().scaledToFill()
                                            } placeholder: {
                                                Rectangle().fill(Color.gray.opacity(0.3))
                                            }
                                        }
                                        .clipped()
                                        .cornerRadius(8)
                                    Text(item.displayName)
                                        .font(.caption)
                                        .foregroundColor(.white)
                                        .lineLimit(1)
                                        .frame(width: 130, alignment: .leading)
                                }
                            }
                            .buttonStyle(.plain)
                            .simultaneousGesture(TapGesture().onEnded {
                                onSelect(item)
                            })
                        }
                    }
                    .padding(.horizontal)
                }
            }
        }
    }
}
// MARK: - 1. The Scrollable Homepage Catalogue
struct ContentView: View {
    @StateObject private var viewModel = CastViewModel(engine: FakeCastEngine())
    @StateObject private var homeVM = HomeViewModel()
    @StateObject private var miniPlayer: MiniPlayerInteractor
    @StateObject private var player: PlayerInteractor
    @State private var isShowingCastSheet = false
    @State private var showExpandedPlayer = false

    init() {
        let engine = FakeCastEngine()                 // ONE engine...
        _miniPlayer = StateObject(wrappedValue: MiniPlayerInteractor(engine: engine))
        _player     = StateObject(wrappedValue: PlayerInteractor(engine: engine))  // ...shared
    }

    var body: some View {
        NavigationView {
            ZStack {
                Color.black.ignoresSafeArea()

                if homeVM.isLoading {
                    ProgressView("Loading Content...")
                        .foregroundColor(.white)
                } else {
                    ScrollView {
                        VStack(alignment: .leading, spacing: 20) {

                            // Featured Banner (Top Item)
                            if let featured = homeVM.trendingItems.first {
                                NavigationLink(destination: PlayerDetailView(media: featured, viewModel: viewModel)) {
                                    ZStack(alignment: .bottomLeading) {
                                        Color.clear
                                            .frame(maxWidth: .infinity)
                                            .frame(height: 350)
                                            .overlay {
                                                AsyncImage(url: featured.backdropURL) { image in
                                                    image.resizable().scaledToFill()
                                                } placeholder: {
                                                    Rectangle().fill(Color.gray.opacity(0.3))
                                                }
                                            }
                                            .clipped()

                                        LinearGradient(
                                            colors: [Color.black.opacity(0), Color.black],
                                            startPoint: .top, endPoint: .bottom
                                        )

                                        VStack(alignment: .leading, spacing: 4) {
                                            Text("FEATURED TODAY")
                                                .font(.caption).bold()
                                                .foregroundColor(.cyan)
                                            Text(featured.displayName)
                                                .font(.title).bold()
                                                .foregroundColor(.white)
                                        }
                                        .padding()
                                    }
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 350)
                                    .clipped()
                                }
                                .buttonStyle(.plain)
                                .simultaneousGesture(TapGesture().onEnded {
                                    miniPlayer.play(featured)
                                })

                            }

                            // Original + three NEW rows, all reusing MediaRow
                            MediaRow(title: "Trending Now",     items: homeVM.trendingItems, viewModel: viewModel, onSelect: { miniPlayer.play($0) })
                            MediaRow(title: "Popular Movies",   items: homeVM.popularMovies, viewModel: viewModel, onSelect: { miniPlayer.play($0) })
                            MediaRow(title: "Top Rated",        items: homeVM.topRated,      viewModel: viewModel, onSelect: { miniPlayer.play($0) })
                            MediaRow(title: "Popular TV Shows", items: homeVM.popularTV,     viewModel: viewModel, onSelect: { miniPlayer.play($0) })
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.bottom, 30)
                    }
                }
            }
            .navigationTitle("MAX")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        isShowingCastSheet = true
                        viewModel.startDiscovering()
                    }) {
                        if case .connected = viewModel.state {
                            Image(systemName: "tv.badge.wifi.fill")
                                .foregroundColor(.blue)
                        } else {
                            Image(systemName: "tv.badge.wifi")
                                .foregroundColor(.white)
                        }
                    }
                }
            }
            .sheet(isPresented: $isShowingCastSheet, onDismiss: {
                if case .discovering = viewModel.state {
                    viewModel.stopDiscovering()
                }
            }) {
                CastSheetView(viewModel: viewModel)
            }
        }
        .accentColor(.white)
        .environmentObject(player)                    // share with PlayerDetailView
        .safeAreaInset(edge: .bottom) {
            if case .connected = viewModel.state {
                MiniPlayerBar(interactor: miniPlayer)
                    .contentShape(Rectangle())        // makes the whole bar tappable
                    .onTapGesture { showExpandedPlayer = true }
            }
        }
        .fullScreenCover(isPresented: $showExpandedPlayer) {
            PlayerView(interactor: player)
        }
        .task {
            await homeVM.loadHomeContent()
            miniPlayer.start()
        }
    }
}

// MARK: - 2. The Detail & Player Screen
struct PlayerDetailView: View {
    @EnvironmentObject private var player: PlayerInteractor
    let media: MediaItem
    @ObservedObject var viewModel: CastViewModel
    @State private var isShowingCastSheet = false
    @State private var showPlayer = false

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            VStack(alignment: .leading, spacing: 0) {
                // Video Player Area
                ZStack {
                    Color.black
                        .frame(maxWidth: .infinity)
                        .frame(height: 250)
                        .overlay {
                            AsyncImage(url: media.backdropURL) { image in
                                image.resizable().scaledToFill()
                            } placeholder: {
                                Color.gray.opacity(0.2)
                            }
                        }
                        .clipped()

                    if case .connected(let device) = viewModel.state {
                        VStack {
                            Image(systemName: "tv.badge.wifi.fill")
                                .font(.system(size: 40))
                                .foregroundColor(.blue)
                            Text("Playing on \(device.name)")
                                .font(.headline)
                                .foregroundColor(.white)
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(Color.black.opacity(0.75))
                    } else {
                        Button {
                            showPlayer = true
                        } label: {
                            Image(systemName: "play.circle.fill")
                                .font(.system(size: 60))
                                .foregroundColor(.white)
                        }
                    }
                }
                .frame(height: 250)

                ScrollView {
                    VStack(alignment: .leading, spacing: 12) {
                        Text(media.displayName)
                            .font(.title)
                            .bold()
                            .foregroundColor(.white)

                        Text(media.overview ?? "No description available.")
                            .font(.body)
                            .foregroundColor(.gray)

                        Spacer()
                    }
                    .padding()
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .fullScreenCover(isPresented: $showPlayer) {
            PlayerView(interactor: player)
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    isShowingCastSheet = true
                    viewModel.startDiscovering()
                }) {
                    if case .connected = viewModel.state {
                        Image(systemName: "tv.badge.wifi.fill")
                            .foregroundColor(.blue)
                    } else {
                        Image(systemName: "tv.badge.wifi")
                            .foregroundColor(.white)
                    }
                }
            }
        }
        .sheet(isPresented: $isShowingCastSheet, onDismiss: {
            if case .discovering = viewModel.state {
                viewModel.stopDiscovering()
            }
        }) {
            CastSheetView(viewModel: viewModel)
        }
    }
}

// MARK: - 3. The Cast Device Picker Sheet
struct CastSheetView: View {
    @ObservedObject var viewModel: CastViewModel
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationView {
            VStack {
                switch viewModel.state {
                case .discovering, .disconnected, .failed:
                    if viewModel.availableDevices.isEmpty {
                        VStack(spacing: 20) {
                            ProgressView()
                            Text("Looking for devices...")
                                .foregroundColor(.gray)
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    } else {
                        List(viewModel.availableDevices) { device in
                            Button(action: {
                                viewModel.connect(to: device)
                            }) {
                                HStack {
                                    Image(systemName: device.type == .tv ? "tv" : "display")
                                    Text(device.name)
                                        .foregroundColor(.primary)
                                    Spacer()
                                }
                            }
                        }
                    }

                case .connecting(let device):
                    VStack(spacing: 20) {
                        ProgressView()
                        Text("Connecting to \(device.name)...")
                            .font(.headline)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)

                case .connected(let device), .reconnecting(let device):
                    VStack(spacing: 20) {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 60))
                            .foregroundColor(.green)
                        Text("Connected to \(device.name)")
                            .font(.headline)

                        Button("Disconnect") {
                            viewModel.disconnect()
                            dismiss()
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(.red)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            }
            .navigationTitle("Cast to...")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Close") { dismiss() }
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
