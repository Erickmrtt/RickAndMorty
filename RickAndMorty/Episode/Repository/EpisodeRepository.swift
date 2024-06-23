//
//  EpisodeRepository.swift
//  RickAndMorty
//
//  Created by erick on 22/06/24.
//

import Foundation
import Alamofire

class EpisodeRepository {
    func fetchEpisodes() async throws -> EpisodeModel {
        let url = "https://rickandmortyapi.com/api/episode"
        return try await withUnsafeThrowingContinuation { continuation in
            AF.request(url, method: .get, encoding: URLEncoding.default)
                .response { response in
                    switch response.result {
                        case .success(let data):
                            do {
                                let jsonData = try JSONDecoder().decode(EpisodeModel.self, from: data!)
                                continuation.resume(returning: jsonData)
                            } catch {
                                continuation.resume(throwing: error)
                            }
                        case .failure(let error):
                            continuation.resume(throwing: error)
                }
            }
        }
    }
}
