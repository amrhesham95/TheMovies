//
//  MovieRowView.swift
//  TheMovies
//
//  Created by Amr Hassan on 29.04.25.
//

import SwiftUI
import SDWebImageSwiftUI

struct MovieRowView: View {
    let movie: Movie
    
    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            WebImage(url: movie.posterURL)
                .resizable()
                .frame(width: 100, height: 150)
                .cornerRadius(10)
            
            VStack(alignment: .leading, spacing: 8) {
                Text(movie.title)
                    .font(.headline)
                
                Text(movie.releaseDate)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                Text(movie.overview)
                    .font(.body)
                    .lineLimit(4)
                    .foregroundColor(.secondary)
            }
        }
        .padding(.vertical, 8)
    }
}

