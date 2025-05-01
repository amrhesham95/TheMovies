//
//  MockFetchLatestMoviesUseCase.swift
//  TheMoviesTests
//
//  Created by Amr Hassan on 01.05.25.
//

import Foundation
@testable import TheMovies

class MockFetchLatestMoviesUseCase: FetchLatestMoviesUseCase {
    var shouldFail = false

    func execute(page: Int) async throws -> [Movie] {
        if shouldFail {
            throw URLError(.badServerResponse)
        }
        return Movie.mock
    }
}
