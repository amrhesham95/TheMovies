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
    @Published var searchText = ""
    @Published var suggestions: [String] = []
    
    private var currentPage = 1
    private var service: MovieServiceProtocol
    private var isSearching = false
    
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
    
    func searchMovies() async {
        guard !searchText.isEmpty else {
            movies = []
            currentPage = 1
            await fetchMovies()
            return
        }
        
        isLoading = true
        defer { isLoading = false }
        
        do {
            let results = try await (service as! MovieService).searchMovies(query: searchText)
            movies = results
        } catch {
            print("Search error: \(error)")
        }
    }
    
    func updateSuggestions() {
        let lowercasedQuery = searchText.lowercased()
        suggestions = movies
            .map { $0.title }
            .filter { $0.lowercased().hasPrefix(lowercasedQuery) }
    }
}
