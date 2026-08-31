//
//  MiniPlayerBar.swift
//  Phase_3
//
//  Created by neermita.bhattacharya@wbd.com on 19/08/26.
//

import SwiftUI

struct MiniPlayerBar: View {
    @ObservedObject var interactor: MiniPlayerInteractor

    var body: some View {
        switch interactor.viewState {
        case .idle, .loading:
            EmptyView()

        case .failed(let message):
            Text(message).font(.caption).foregroundColor(.red).padding()

        case .loaded(let data):
            HStack(spacing: Theme.Spacing.m) {
                Color.clear
                    .frame(width: Theme.Size.artworkThumb, height: Theme.Size.artworkThumb)
                    .overlay {
                        AsyncImage(url: data.artworkURL) { image in
                            image.resizable().scaledToFill()
                        } placeholder: {
                            Rectangle().fill(Theme.Palette.surfaceMuted)
                                .overlay(Image(systemName: "play.rectangle.fill")
                                    .foregroundColor(Theme.Palette.primaryText))
                        }
                    }
                    .frame(width: Theme.Size.artworkThumb, height: Theme.Size.artworkThumb)
                    .clipped()
                    .cornerRadius(Theme.Radius.s)
                    .accessibilityHidden(true)               // decorative artwork

                VStack(alignment: .leading, spacing: Theme.Spacing.xxs) {
                    Text(data.title).font(.subheadline).bold()
                        .foregroundColor(Theme.Palette.primaryText).lineLimit(1)
                    Text(data.subtitle).font(.caption)
                        .foregroundColor(Theme.Palette.secondaryText).lineLimit(1)
                }

                Spacer()

                Button(action: { interactor.togglePlayPause() }) {
                    Image(systemName: data.isPlaying ? "pause.fill" : "play.fill")
                        .font(.title2).foregroundColor(Theme.Palette.primaryText)
                }
                .accessibilityLabel(data.isPlaying ? "Pause" : "Play")
                .accessibilityHint("Toggles playback")
            }
            .padding(.horizontal, Theme.Spacing.m)
            .padding(.vertical, Theme.Spacing.s)
            .background(Theme.Palette.surface)
            .cornerRadius(Theme.Radius.l)
            .padding(.horizontal, Theme.Spacing.l)        }
    }
}
