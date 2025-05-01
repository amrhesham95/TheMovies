//
//  MockSearchMoviesUseCase.swift
//  TheMoviesTests
//
//  Created by Amr Hassan on 01.05.25.
//

import Foundation
@testable import TheMovies

class MockSearchMoviesUseCase: SearchMoviesUseCase {
    var shouldFail = false
    var searchMoviesIsExecuted = false

    func execute(query: String) async throws -> [Movie] {
        searchMoviesIsExecuted = true
        if shouldFail {
            throw URLError(.badServerResponse)
        }
        return Movie.mock.filter { $0.title.lowercased().contains(query.lowercased()) }
    }
}
