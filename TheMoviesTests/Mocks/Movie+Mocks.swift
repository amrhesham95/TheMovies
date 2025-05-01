//
//  Movie+Mocks.swift
//  TheMoviesTests
//
//  Created by Amr Hassan on 01.05.25.
//

import Foundation
@testable import TheMovies
extension Movie {
    static var mock: [Movie] {
        return [
            Movie(
                adult: false,
                backdropPath: "/path1.jpg",
                genreIds: [28, 12],
                id: 1,
                originalLanguage: "en",
                originalTitle: "The Shawshank Redemption",
                overview: "Two imprisoned men bond over a number of years...",
                popularity: 80.0,
                posterPath: "/poster1.jpg",
                releaseDate: "1994-09-23",
                title: "The Shawshank Redemption",
                video: false,
                voteAverage: 9.3,
                voteCount: 20000
            ),
            Movie(
                adult: false,
                backdropPath: "/path2.jpg",
                genreIds: [28, 80],
                id: 2,
                originalLanguage: "en",
                originalTitle: "The Dark Knight",
                overview: "Batman raises the stakes in his war on crime...",
                popularity: 85.0,
                posterPath: "/poster2.jpg",
                releaseDate: "2008-07-18",
                title: "The Dark Knight",
                video: false,
                voteAverage: 9.0,
                voteCount: 25000
            )
        ]
    }
}
