//
//  MoviesResponse.swift
//  TheMovies
//
//  Created by Amr Hassan on 28.04.25.
//

import Foundation

struct MoviesResponse: Codable {
    let page: Int
    let results: [Movie]
}
