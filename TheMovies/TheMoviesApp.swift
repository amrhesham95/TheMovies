//
//  TheMoviesApp.swift
//  TheMovies
//
//  Created by Amr Hassan on 28.04.25.
//

import SwiftUI

@main
struct TheMoviesApp: App {
    var body: some Scene {
        WindowGroup {
            MovieListView<MovieListViewModel>(viewModel: MovieListViewModel())
        }
    }
}
