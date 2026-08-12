import SwiftUI

// MARK: - The Home Page
struct ContentView: View {
    @StateObject private var viewModel = CastViewModel(engine : FakeCastEngine())
    @State private var isShowingSheet = false
    
    var body: some View {
        NavigationView {
            VStack {
                Rectangle()
                    .fill(Color.black)
                    .frame(height: 250)
                    .overlay(
                        Image(systemName: "play.circle.fill")
                            .font(.system(size: 60))
                            .foregroundColor(.white)
                    )
                
                Text("Dune: Part Two")
                    .font(.title).bold()
                    .padding()
                
                Spacer()
            }
            .navigationTitle("HBO MAX")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        isShowingSheet = true
                        viewModel.startDiscovering()
                    }) {
                        if case .connected = viewModel.state {
                            Image(systemName: "tv.badge.wifi.fill")
                                .foregroundColor(.blue)
                        } else {
                            Image(systemName: "tv.badge.wifi")
                                .foregroundColor(.primary)
                        }
                    }
                }
            }
            .sheet(isPresented: $isShowingSheet, onDismiss: {
                if case .discovering = viewModel.state {
                    viewModel.stopDiscovering()
                }
            }) {
                CastSheetView(viewModel: viewModel)
            }
        }
    }
}

// MARK: - The Cast Device Picker Sheet
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
