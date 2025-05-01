//
//  MockNetworkService.swift
//  TheMoviesTests
//
//  Created by Amr Hassan on 01.05.25.
//

import XCTest
@testable import TheMovies

class MockNetworkService: NetworkServiceProtocol {
    private let mockData: Data
    
    init(mockDataFileName: String = "MockMoviesResponse", fileExtension: String = "json") {
        guard let url = Bundle(for: type(of: self)).url(forResource: mockDataFileName, withExtension: fileExtension) else {
            fatalError("Failed to find mock data file.")
        }
        
        do {
            self.mockData = try Data(contentsOf: url)
        } catch {
            fatalError("Failed to load mock data: \(error)")
        }
    }
    
    func request<T: Decodable>(_ endpoint: URL) async throws -> T {
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: mockData)
    }
}
