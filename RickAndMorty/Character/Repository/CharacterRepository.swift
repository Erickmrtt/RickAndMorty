//
//  CharacterRepository.swift
//  RickAndMorty
//
//  Created by erick on 21/06/24.
//

import Foundation
import Alamofire

class CharacterRepository {
    @Dependency var networkManager: NetworkManager
    let BASE_URL = "https://rickandmortyapi.com/api"

    var urlString: String {
        return  "\(BASE_URL)/character"
    }
    func fetchCharacters() async throws -> CharacterModel {
        let url = "https://rickandmortyapi.com/api/character";
        return try await withUnsafeThrowingContinuation { continuation in
            AF.request(url, method: .get, encoding: URLEncoding.default)
                .response { response in
                    switch response.result {
                        case .success(let data):
                            do {
                                let jsonData = try JSONDecoder().decode(CharacterModel.self, from: data!)
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
    func fetchAllCharacters() async throws -> CharacterModel {
        do {
            guard let url = URL(string: urlString) else {
                print("DEBUG: Invalid URL")
                throw NetworkError.badUrl
            }
            let (data, response) = try await URLSession.shared.data(from: url)
            guard (response as? HTTPURLResponse)?.statusCode == 200 else {
                print("DEBUG: Server error")
                throw NetworkError.badResponse
            }
            guard let characters = try? JSONDecoder().decode(CharacterModel.self, from: data) else {
                print("DEBUG: Invalid data")
                throw NetworkError.failedToDecodeResponse
            }

            return characters

        } catch NetworkError.badUrl {
            print("There was an error creating the URL")
            throw NetworkError.badUrl
        } catch NetworkError.badResponse {
            print("Did not get a valid response")
            throw NetworkError.badResponse
        } catch NetworkError.badStatus {
            print("Did not get a 2xx status code from the response")
            throw NetworkError.badStatus
        } catch NetworkError.failedToDecodeResponse {
            print("Failed to decode response into the given type")
            throw NetworkError.failedToDecodeResponse
        } catch {
            print("An error occurred downloading the data")
            throw NetworkError.badResponse
        }
    }
}
