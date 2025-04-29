//
//  MovieListViewModel.swift
//  TheMovies
//
//  Created by Amr Hassan on 29.04.25.
//

import Foundation
@MainActor
final class MovieListViewModel: ObservableObject {
    @Published var movies: [Movie] = []
    @Published var isLoading = false
    private var currentPage = 1
    private var service: MovieServiceProtocol

    init(service: MovieServiceProtocol = MovieService()) {
        self.service = service
    }
    
    func fetchMovies() async {
        guard !isLoading else { return }
        isLoading = true
        do {
            let newMovies = try await service.fetchLatestMovies(page: currentPage)
            movies.append(contentsOf: newMovies)
            currentPage += 1
        } catch {
            print("Failed to fetch movies: \(error)")
        }
        isLoading = false
    }
}
