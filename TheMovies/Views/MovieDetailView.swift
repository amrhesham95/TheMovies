//
//  MovieDetailView.swift
//  TheMovies
//
//  Created by Amr Hassan on 29.04.25.
//

import SwiftUI
import SDWebImageSwiftUI

struct MovieDetailView: View {
    let movie: Movie
    
    var body: some View {
        ScrollView {

            LazyVStack(alignment: .leading, spacing: 16) {
                WebImage(url: movie.backdropURL)
                    .resizable()
                    .scaledToFill()
                    .frame(height: 250)
                    .clipped()

                VStack(alignment: .leading, spacing: 16) {
                    Text(movie.title)
                        .font(.largeTitle)
                        .bold()
                    
                    Text("Release Date: \(movie.releaseDate)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    HStack {
                        Text("Rating: \(String(format: "%.1f", movie.voteAverage))")
                        Spacer()
                        Text("Votes: \(movie.voteCount)")
                    }
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    
                    Divider()
                    
                    Text(movie.overview)
                        .font(.body)
                }
                .padding(.horizontal)
            }
        }
    }
}

