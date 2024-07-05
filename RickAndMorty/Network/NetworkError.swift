//
//  NetworkError.swift
//  RickAndMorty
//
//  Created by erick on 21/06/24.
//

import Foundation

enum NetworkError: Error {
    case badUrl
    case invalidRequest
    case badResponse
    case badStatus
    case failedToDecodeResponse
}
extension NetworkError {
    var localizedDescription: String {
        switch self {
            case .badUrl:
                return "Invalid URL"
            case .failedToDecodeResponse:
                return "There was an error decoding the type"
            case .invalidRequest:
                return "Invalid Request"
            case .badResponse:
                return "Invalid response"
            case .badStatus:
                return "Bad status"
        }
    }
}
