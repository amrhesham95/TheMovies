//
//  TheMoviesApp.swift
//  TheMovies
//
//  Created by Amr Hassan on 28.04.25.
//

import SwiftUI

@main
struct TheMoviesApp: App {
    private let container = AppContainer()

    var body: some Scene {
        WindowGroup {
            MovieListView(viewModel: container.movieListViewModel)
        }
    }
}
