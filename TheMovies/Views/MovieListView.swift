//
//  MovieListView.swift
//  TheMovies
//
//  Created by Amr Hassan on 29.04.25.
//

import SwiftUI

struct MovieListView: View {
    @StateObject private var viewModel = MovieListViewModel()
    
    var body: some View {
        NavigationStack {
            List(viewModel.movies, id: \.self.id) { movie in                
                NavigationLink(destination: MovieDetailView(movie: movie)) {
                    MovieRowView(movie: movie)
                        .onAppear {
                            if movie == viewModel.movies.last {
                                Task {
                                    await viewModel.fetchMovies()
                                }
                            }
                        }
                }
            }
            .navigationTitle("Latest Movies")
            .task {
                await viewModel.fetchMovies()
            }
        }
    }
}

