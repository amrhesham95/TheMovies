//
//  NetworkService.swift
//  TheMovies
//
//  Created by Amr Hassan on 28.04.25.
//

import Foundation

protocol NetworkServiceProtocol {
    func request<T: Decodable>(_ endpoint: URL) async throws -> T
}

final class NetworkService: NetworkServiceProtocol {
    func request<T: Decodable>(_ endpoint: URL) async throws -> T {
        let (data, response) = try await URLSession.shared.data(from: endpoint)
        
        guard let httpResponse = response as? HTTPURLResponse,
              200..<300 ~= httpResponse.statusCode else {
            throw URLError(.badServerResponse)
        }
        
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
    }
}
