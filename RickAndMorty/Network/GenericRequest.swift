//
//  GenericRequest.swift
//  RickAndMorty
//
//  Created by erick on 04/07/24.
//

import Foundation

final class GenericRequest {
    @MainActor
    func genericApiCall<T:Codable> (url: URL?) async throws -> T{
        guard let url = url else { throw NetworkError.badUrl }
        let (data, response) = try await URLSession.shared.data(from: url)
        guard (response as? HTTPURLResponse)?.statusCode == 200 else { throw NetworkError.badResponse }
        guard let decode = try? JSONDecoder().decode(T.self, from: data) else {throw NetworkError.failedToDecodeResponse}
        return decode

    }
}
