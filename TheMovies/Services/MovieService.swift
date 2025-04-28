//
//  MovieService.swift
//  TheMovies
//
//  Created by Amr Hassan on 28.04.25.
//

import Foundation

protocol MovieServiceProtocol {
    func fetchLatestMovies(page: Int) async throws -> [Movie]
    func searchMovies(query: String) async throws -> [Movie]
}

final class MovieService: MovieServiceProtocol {
    private let networkService: NetworkServiceProtocol
    private let apiKey = "53fe06c2962928e5757c34490a1fbf9a"
    
    init(networkService: NetworkServiceProtocol = NetworkService()) {
        self.networkService = networkService
    }
    
    func fetchLatestMovies(page: Int) async throws -> [Movie] {
        let urlString = "https://api.themoviedb.org/3/movie/now_playing?api_key=\(apiKey)&page=\(page)"
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        
        let response: MoviesResponse = try await networkService.request(url)
        return response.results
    }
    
    func searchMovies(query: String) async throws -> [Movie] {
        guard let queryEncoded = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            throw URLError(.badURL)
        }
        
        let urlString = "https://api.themoviedb.org/3/search/movie?api_key=\(apiKey)&query=\(queryEncoded)"
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        
        let response: MoviesResponse = try await networkService.request(url)
        return response.results
    }
}
