//
//  FetchLatestMoviesUseCase.swift
//  TheMovies
//
//  Created by Amr Hassan on 29.04.25.
//

import Foundation

protocol FetchLatestMoviesUseCase {
    func execute(page: Int) async throws -> [Movie]
}

final class FetchLatestMoviesUseCaseImpl: FetchLatestMoviesUseCase {
    private let service: MovieServiceProtocol

    init(service: MovieServiceProtocol = MovieService()) {
        self.service = service
    }

    func execute(page: Int) async throws -> [Movie] {
        try await service.fetchLatestMovies(page: page)
    }
}
