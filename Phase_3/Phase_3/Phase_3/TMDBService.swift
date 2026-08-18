import Foundation
import Combine

struct TMDBResponse: Codable {
    let results: [MediaItem]
}

struct MediaItem: Codable, Identifiable {
    let id: Int
    let title: String?
    let name: String?
    let posterPath: String?
    let backdropPath: String?
    let overview: String?
    let mediaType: String?

    var displayName: String {
        title ?? name ?? "Unknown Title"
    }
    
    var posterURL: URL? {
        guard let path = posterPath else { return nil }
        return URL(string: "https://image.tmdb.org/t/p/w500\(path)")
    }
    
    var backdropURL: URL? {
        guard let path = backdropPath else { return nil }
        return URL(string: "https://image.tmdb.org/t/p/w1280\(path)")
    }
}

class TMDBService {
    static let shared = TMDBService()
    private let apiKey = "d190ec51f59b4fcca47901cb812eaa28"
    private let baseURL = "https://api.themoviedb.org/3"

    // Generic fetch for any list endpoint
    private func fetch(path: String) async throws -> [MediaItem] {
        guard let url = URL(string: "\(baseURL)\(path)?api_key=\(apiKey)") else {
            throw URLError(.badURL)
        }

        let (data, response) = try await URLSession.shared.data(from: url)

        // Surface real HTTP errors (e.g. 401 bad key) instead of silent empties
        if let http = response as? HTTPURLResponse, !(200...299).contains(http.statusCode) {
            throw URLError(.badServerResponse)
        }

        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase   // maps poster_path -> posterPath
        return try decoder.decode(TMDBResponse.self, from: data).results
    }

    func fetchTrending() async throws -> [MediaItem]     { try await fetch(path: "/trending/all/day") }
    func fetchPopularMovies() async throws -> [MediaItem] { try await fetch(path: "/movie/popular") }
    func fetchTopRated() async throws -> [MediaItem]      { try await fetch(path: "/movie/top_rated") }
    func fetchPopularTV() async throws -> [MediaItem]     { try await fetch(path: "/tv/popular") }
}

