//
//  MovieListViewModelTests.swift
//  TheMoviesTests
//
//  Created by Amr Hassan on 01.05.25.
//

import XCTest
@testable import TheMovies
import Combine

@MainActor
final class MovieListViewModelTests: XCTestCase {
    
    var viewModel: MovieListViewModel!
    var mockFetchUseCase: MockFetchLatestMoviesUseCase!
    var mockSearchUseCase: MockSearchMoviesUseCase!
    var cancellables: Set<AnyCancellable> = []
    
    override func setUp() {
        super.setUp()
        mockFetchUseCase = MockFetchLatestMoviesUseCase()
        mockSearchUseCase = MockSearchMoviesUseCase()
        viewModel = MovieListViewModel(
            fetchMoviesUseCase: mockFetchUseCase,
            searchUseCase: mockSearchUseCase
        )
    }
    
    override func tearDown() {
        viewModel = nil
        mockFetchUseCase = nil
        mockSearchUseCase = nil
        super.tearDown()
    }
    
    func test_fetchMovies_success() async {
        
        await viewModel.fetchMovies()
        
        XCTAssertEqual(viewModel.movies.count, Movie.mock.count)
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertEqual(viewModel.suggestions.sorted(), Movie.mock.map { $0.title }.sorted())
    }
    
    func test_fetchMovies_failure() async {
        mockFetchUseCase.shouldFail = true
        
        await viewModel.fetchMovies()
        
        XCTAssertFalse(viewModel.errorMessage.isEmpty)
    }
    
    func test_whenTextIsUpdated_searchIsExecutedsuccess() {
        // given
        let expectedMovie = Movie.mock.first!
        let expectation = XCTestExpectation(description: "movies updated after search")
        
        viewModel.$movies
            .dropFirst() // Ignore the initial value
            .sink { movies in
                if movies.count == 1 && movies.first?.id == expectedMovie.id {
                    // then
                    XCTAssertTrue(self.mockSearchUseCase.searchMoviesIsExecuted)
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        
        // when
        viewModel.searchText = expectedMovie.title
        
        wait(for: [expectation], timeout: 2.0)
    }
    
    func test_searchMovies_failure() async {
        mockSearchUseCase.shouldFail = true
        viewModel.searchText = "fail"
        
        try? await Task.sleep(nanoseconds: 500_000_000)
        
        XCTAssertFalse(viewModel.errorMessage.isEmpty)
    }
    
    func test_searchText_emptyTriggersFetchMovies() async {
        viewModel.searchText = ""
        
        try? await Task.sleep(nanoseconds: 500_000_000)
        
        XCTAssertEqual(viewModel.movies.count, Movie.mock.count)
    }
    
    func test_fetchMovies_sets_isLoading_true_then_false() async {
        // given:
        let expectationLoadingStart = XCTestExpectation(description: "isLoading should be true")
        let expectationLoadingEnd = XCTestExpectation(description: "isLoading should be false after fetchMovies completes")
        
        // Observe
        viewModel.$isLoading
            .sink { isLoading in
                if isLoading {
                    expectationLoadingStart.fulfill()
                } else {
                    expectationLoadingEnd.fulfill()
                }
            }
            .store(in: &cancellables)
        
        // when: Call fetchMovies() and check isLoading
        await viewModel.fetchMovies()
        
        // then
        await fulfillment(of: [expectationLoadingStart], timeout: 1) // Wait for loading to start
        await fulfillment(of: [expectationLoadingEnd], timeout: 1) // Wait for loading to end
    }
}
