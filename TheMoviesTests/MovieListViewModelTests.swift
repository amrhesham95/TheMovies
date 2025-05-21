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
        
    func test_fetchMovies_whenApiCallFinished_isLoadingIsFalse() async {
        let expectation = XCTestExpectation(description: "loading is set to false after fetch api call finishes")
        viewModel.$isLoading
            .dropFirst(2)
            .receive(on: RunLoop.main)
            .sink { isLoading in
                
                // then
                XCTAssertFalse(isLoading)
                expectation.fulfill()
            }.store(in: &cancellables)
        
        // when
        viewModel.onAppear()
        
        await fulfillment(of: [expectation], timeout: 2.0)
    }
    
    func test_fetchMovies_whenApiCallFinished_suggestionsUpdated() async {
        let expectation = XCTestExpectation(description: "movies suggestions updated after fetch api call")
        viewModel.$suggestions
            .dropFirst() // Ignore the initial value
            .receive(on: RunLoop.main)
            .sink { suggestions in
                
                // then
                XCTAssertEqual(suggestions.sorted(), Movie.mock.map { $0.title }.sorted())
                expectation.fulfill()
            }.store(in: &cancellables)
        
        // when
        viewModel.onAppear()
        
        await fulfillment(of: [expectation], timeout: 2.0)
    }
    
    func test_fetchMovies_failure() {
        let expectation = XCTestExpectation(description: "error message is set after fetch api call failure")
        mockFetchUseCase.shouldFail = true
        
        viewModel.$errorMessage
            .dropFirst()
            .receive(on: RunLoop.main)
            .sink { [weak self] errorMessage in
                
                // then
                guard let self = self else { return }
                XCTAssertEqual(self.viewModel.errorMessage, errorMessage)
                expectation.fulfill()
            }.store(in: &cancellables)
        
        // when
        viewModel.onAppear()
        
        wait(for: [expectation])
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
        await viewModel.onAppear()
        
        // then
        await fulfillment(of: [expectationLoadingStart], timeout: 1) // Wait for loading to start
        await fulfillment(of: [expectationLoadingEnd], timeout: 1) // Wait for loading to end
    }
}
