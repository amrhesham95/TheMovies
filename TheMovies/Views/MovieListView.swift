//
//  MovieListView.swift
//  TheMovies
//
//  Created by Amr Hassan on 29.04.25.
//

import SwiftUI

struct MovieListView<ViewModel: MovieListViewModelProtocol>: View {
    @StateObject private var viewModel: ViewModel
    @State private var hasLoaded = false
    
    init(viewModel: ViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                List(viewModel.movies) { movie in
                    NavigationLink(destination: MovieDetailView(movie: movie)) {
                        MovieRowView(movie: movie)
                            .onAppear {
                                if movie == viewModel.movies.last && viewModel.searchText.isEmpty {
                                    
                                    viewModel.onAppear()
                                    
                                }
                            }
                    }
                }
                if viewModel.isLoading {
                    HStack {
                        Spacer()
                        ProgressView()
                        Spacer()
                    }
                }
            }
        }
        .navigationTitle("Latest Movies")
        .searchable(text: $viewModel.searchText, prompt: "Search movies...") {
            ForEach(viewModel.suggestions, id: \.self) { suggestion in
                Text(suggestion)
                    .searchCompletion(suggestion)
            }
        }
        .onAppear {
            if !hasLoaded {
                hasLoaded = true
                viewModel.onAppear()
            }
        }
        .toast(message: $viewModel.errorMessage)
    }
}
