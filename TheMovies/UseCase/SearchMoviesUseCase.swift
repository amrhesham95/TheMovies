//
//  SearchMoviesUseCase.swift
//  TheMovies
//
//  Created by Amr Hassan on 29.04.25.
//

import Foundation
protocol SearchMoviesUseCase {
    func execute(query: String) async throws -> [Movie]
}

final class SearchMoviesUseCaseImpl: SearchMoviesUseCase {
    private let service: MovieServiceProtocol

    init(service: MovieServiceProtocol) {
        self.service = service
    }

    func execute(query: String) async throws -> [Movie] {
        try await service.searchMovies(query: query)
    }
}
