//
//  SearchMoviesUseCase.swift
//  TheMoviesTests
//
//  Created by Amr Hassan on 01.05.25.
//

import XCTest
@testable import TheMovies

final class SearchMoviesUseCaseTests: XCTestCase {

    var movieService: MovieServiceProtocol!
    var useCase: SearchMoviesUseCase!

    override func setUp() {
        super.setUp()
        movieService = MockMovieService()
        useCase = SearchMoviesUseCaseImpl(service: movieService)
    }

    func test_search_success_returnsMovies() async throws {
        // Given: search query
        let query = "The Shawshank Redemption"

        // When: perform search
        let movies = try await useCase.execute(query: query)

        // Then: check results
        XCTAssertEqual(movies.count, 1)
        XCTAssertEqual(movies.first?.title, "The Shawshank Redemption")
    }

    func test_search_emptyQuery_returnsEmptyMovies() async throws {
        // Given: empty search query
        let query = "zxczxczxczxczx"

        // When: perform search
        let movies = try await useCase.execute(query: query)

        // Then: check that no movies are returned
        XCTAssertTrue(movies.isEmpty)
    }
}
