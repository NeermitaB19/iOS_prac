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
            HStack(spacing: 12) {
                Color.clear
                    .frame(width: 48, height: 48)
                    .overlay {
                        AsyncImage(url: data.artworkURL) { image in
                            image.resizable().scaledToFill()
                        } placeholder: {
                            Rectangle().fill(Color.gray.opacity(0.4))
                                .overlay(Image(systemName: "play.rectangle.fill")
                                    .foregroundColor(.white))
                        }
                    }
                    .frame(width: 48, height: 48)
                    .clipped()
                    .cornerRadius(6)

                VStack(alignment: .leading, spacing: 2) {
                    Text(data.title).font(.subheadline).bold()
                        .foregroundColor(.white).lineLimit(1)
                    Text(data.subtitle).font(.caption)
                        .foregroundColor(.gray).lineLimit(1)
                }

                Spacer()

                Button(action: { interactor.togglePlayPause() }) {
                    Image(systemName: data.isPlaying ? "pause.fill" : "play.fill")
                        .font(.title2).foregroundColor(.white)
                }
            }
            .padding(.horizontal, 12).padding(.vertical, 8)
            .background(Color(white: 0.15))
            .cornerRadius(12)
            .padding(.horizontal)
        }
    }
}
