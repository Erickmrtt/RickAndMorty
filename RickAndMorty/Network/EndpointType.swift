//
//  EndpointType.swift
//  RickAndMorty
//
//  Created by erick on 22/06/24.
//

import Alamofire

actor NetworkManager {
    func request<T: Decodable>(
        method: HTTPMethod,
        url: String,
        headers: [String: String]? = nil,
        params: Parameters? = nil,
        of type: T.Type
    ) async throws -> T {
        // Set Encoding
        var encoding: ParameterEncoding = JSONEncoding.default
        switch method {
        case .post:
            encoding = JSONEncoding.default
        case .get:
            encoding = URLEncoding.default
        default:
            encoding = JSONEncoding.default
        }

        // You must resume the continuation exactly once
        return try await withCheckedThrowingContinuation { continuation in
            AF.request(
                url,
                method: method,
                parameters: params,
                encoding: encoding,
                headers: HTTPHeaders(headers ?? [:])
            ).responseDecodable(of: type) { response in
                switch response.result {
                case let .success(data):
                    continuation.resume(returning: data)

                case let .failure(error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
}
