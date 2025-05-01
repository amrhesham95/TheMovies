//
//  AppContainer.swift
//  TheMovies
//
//  Created by Amr Hassan on 01.05.25.
//

import Foundation

@MainActor
struct AppContainer {
    let movieService: MovieServiceProtocol
    let fetchMoviesUseCase: FetchLatestMoviesUseCase
    let searchMoviesUseCase: SearchMoviesUseCase
    let movieListViewModel: MovieListViewModel

    init() {
        movieService = MovieService()
        fetchMoviesUseCase = FetchLatestMoviesUseCaseImpl(service: movieService)
        searchMoviesUseCase = SearchMoviesUseCaseImpl(service: movieService)
        movieListViewModel = MovieListViewModel(
            fetchMoviesUseCase: fetchMoviesUseCase,
            searchUseCase: searchMoviesUseCase
        )
    }
}
