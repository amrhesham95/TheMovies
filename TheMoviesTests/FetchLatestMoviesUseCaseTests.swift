//
//  FetchLatestMoviesUseCaseTests.swift
//  TheMoviesTests
//
//  Created by Amr Hassan on 01.05.25.
//

import XCTest
@testable import TheMovies

final class FetchLatestMoviesUseCaseTests: XCTestCase {
    var movieService: MovieServiceProtocol!
    var useCase: FetchLatestMoviesUseCase!

    override func setUp() {
        super.setUp()
        movieService = MockMovieService()
        useCase = FetchLatestMoviesUseCaseImpl(service: movieService)
    }

    func test_execute_returnsMoviesSuccessfully() async throws {
        // when
        let movies = try await useCase.execute(page: 1)

        // then
        XCTAssertFalse(movies.isEmpty)
        XCTAssertEqual(movies.first?.title, "The Shawshank Redemption")
    }
}
