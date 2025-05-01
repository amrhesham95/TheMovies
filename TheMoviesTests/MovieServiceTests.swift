//
//  MovieServiceTests.swift
//  TheMoviesTests
//
//  Created by Amr Hassan on 01.05.25.
//

import XCTest
@testable import TheMovies

final class MovieServiceTests: XCTestCase {
    
    var movieService: MovieService!
    var mockNetworkService: MockNetworkService!
    
    override func setUp() {
        super.setUp()
        // Initialize mock service with predefined data from the JSON file
        mockNetworkService = MockNetworkService(mockDataFileName: "MockMoviesResponse")
        movieService = MovieService(networkService: mockNetworkService)
    }
    
    override func tearDown() {
        movieService = nil
        mockNetworkService = nil
        super.tearDown()
    }
    
    func testFetchLatestMovies() async {
        // when
        do {
            let movies = try await movieService.fetchLatestMovies(page: 1)
            
            // then
            XCTAssertEqual(movies.count, 2)
            XCTAssertEqual(movies.first?.title, "Mock Movie 1")
            XCTAssertEqual(movies.first?.overview, "This is the first mock movie for testing.")
        } catch {
            XCTFail("Expected success, but got error: \(error)")
        }
    }
    
    func testSearchMovies() async {
        // when
        do {
            let movies = try await movieService.searchMovies(query: "mock")
            
            // then
            XCTAssertEqual(movies.count, 2)
        } catch {
            XCTFail("Expected success, but got error: \(error)")
        }
    }
}
