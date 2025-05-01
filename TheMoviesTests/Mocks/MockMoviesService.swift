//
//  MockMoviesService.swift
//  TheMoviesTests
//
//  Created by Amr Hassan on 01.05.25.
//

import XCTest
@testable import TheMovies

class MockMovieService: MovieServiceProtocol {
    func fetchLatestMovies(page: Int) async throws -> [TheMovies.Movie] {
        return Movie.mock
    }
    
    func searchMovies(query: String) async throws -> [TheMovies.Movie] {
        Movie.mock.filter { $0.title.lowercased().contains(query.lowercased()) }
    }
}
