//
//  MovieListViewModel.swift
//  TheMovies
//
//  Created by Amr Hassan on 29.04.25.
//

import Foundation

@MainActor
protocol MovieListViewModelProtocol: ObservableObject {
    var movies: [Movie] { get }
    var isLoading: Bool { get }
    var searchText: String { get set }
    var errorMessage: String { get set }
    var suggestions: [String] { get }

    func onAppear()
    func searchMovies() async
}

@MainActor
final class MovieListViewModel: MovieListViewModelProtocol, ObservableObject {
    @Published var movies: [Movie] = []
    @Published var isLoading = false
    @Published var errorMessage: String = ""
    @Published var searchText = "" {
        didSet {
            debounceSearch()
        }
    }
    @Published var suggestions: [String] = []
    
    private var currentPage = 1
    private var debounceTask: Task<Void, Never>?
    private let fetchMoviesUseCase: FetchLatestMoviesUseCase
    private let searchUseCase: SearchMoviesUseCase
    private var tasks: [Task<Void, Never>] = []
    init(fetchMoviesUseCase: FetchLatestMoviesUseCase,
         searchUseCase: SearchMoviesUseCase) {
        self.fetchMoviesUseCase = fetchMoviesUseCase
        self.searchUseCase = searchUseCase
    }

    func onAppear() {
        let task = Task {
            await fetchMovies()
        }
        tasks.append(task)
    }
    
    private func fetchMovies() async {
        guard !isLoading else { return }
        isLoading = true
        do {
            let newMovies = try await fetchMoviesUseCase.execute(page: currentPage)
            movies.append(contentsOf: newMovies)
            currentPage += 1
            updateSuggestions()
        } catch {
            isLoading = false
            errorMessage = "Failed to fetch movies: \(error.localizedDescription)"
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
            let results = try await searchUseCase.execute(query: searchText)
            movies = results
            updateSuggestions()
        } catch {
            errorMessage = "Search error: \(error.localizedDescription)"
        }
    }

    private func debounceSearch() {
        debounceTask?.cancel()
        debounceTask = Task { [weak self] in
            try? await Task.sleep(nanoseconds: 400_000_000) // 400ms
            guard !Task.isCancelled else { return }
            await self?.searchMovies()
        }
    }

    private func updateSuggestions() {
        let titles = movies.map { $0.title.trimmingCharacters(in: .whitespaces) }
        suggestions = Array(Set(titles)).sorted()
    }
}
