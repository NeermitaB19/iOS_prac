import Foundation
import Combine

@MainActor
class HomeViewModel: ObservableObject {
    @Published var trendingItems: [MediaItem] = []
    @Published var popularMovies: [MediaItem] = []
    @Published var topRated: [MediaItem] = []
    @Published var popularTV: [MediaItem] = []
    @Published var isLoading = false

    func loadHomeContent() async {
        isLoading = true
        defer { isLoading = false }

        do {
            // Fetch all four concurrently, then assign
            async let trending = TMDBService.shared.fetchTrending()
            async let movies   = TMDBService.shared.fetchPopularMovies()
            async let top       = TMDBService.shared.fetchTopRated()
            async let tv        = TMDBService.shared.fetchPopularTV()

            self.trendingItems = try await trending
            self.popularMovies = try await movies
            self.topRated      = try await top
            self.popularTV     = try await tv
        } catch {
            print("Failed to load home content: \(error)")
        }
    }
}
