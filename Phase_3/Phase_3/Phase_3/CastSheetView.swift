//
//  CastSheetView.swift
//  Phase_3
//
//  Created by neermita.bhattacharya@wbd.com on 26/08/26.
//
import Combine
import SwiftUI


// MARK: - 3. The Cast Device Picker Sheet
struct CastSheetView: View {
    @ObservedObject var viewModel: CastViewModel
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationView {
            VStack {
                switch viewModel.state {
                case .discovering, .disconnected:
                    if viewModel.availableDevices.isEmpty {
                        VStack(spacing: Theme.Spacing.xl) {
                            ProgressView()
                            Text("Looking for devices…")
                                .foregroundColor(Theme.Palette.secondaryText)
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .accessibilityElement(children: .combine)
                        .accessibilityLabel("Looking for devices")
                    } else {
                        List(viewModel.availableDevices) { device in
                            Button { viewModel.connect(to: device) } label: {
                                HStack {
                                    Image(systemName: device.type == .tv ? "tv" : "display")
                                    Text(device.name).foregroundColor(.primary)
                                    Spacer()
                                }
                            }
                            .accessibilityLabel("\(device.name), \(device.type.rawValue)")
                            .accessibilityHint("Double tap to connect")
                        }
                    }
                case .failed(let error):
                    VStack(spacing: Theme.Spacing.l) {
                        Image(systemName: "wifi.exclamationmark")
                            .font(.system(size: 40)).foregroundColor(Theme.Palette.live)
                        Text("Connection failed")
                            .font(.headline).foregroundColor(Theme.Palette.primaryText)
                        Text(String(describing: error))
                            .font(.caption).foregroundColor(Theme.Palette.secondaryText)
                        Button("Try Again") { viewModel.startDiscovering() }
                            .buttonStyle(.borderedProminent)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .accessibilityElement(children: .combine)

                case .connecting(let device):
                    VStack(spacing: Theme.Spacing.xl) {
                        ProgressView()
                        Text("Connecting to \(device.name)...")
                            .font(.headline)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)

                case .connected(let device), .reconnecting(let device):
                    VStack(spacing: Theme.Spacing.xl) {
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
