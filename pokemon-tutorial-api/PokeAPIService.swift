//
//  PokeAPIService.swift
//  pokemon-tutorial-api
//
//  Created by Maegan Wilson on 5/3/21.
//

import Foundation

class PokeAPIService {
    public static let shared = PokeAPIService()
    
    private init() {}
    private let urlSession = URLSession.shared
    private let baseURL = URL(string: "https://pokeapi.co/api/v2")!
    
    private let jsonDecoder: JSONDecoder = {
        let jsonDecorder = JSONDecoder()
        return jsonDecorder
    }()
    
    // Endpoints for API
    enum Endpoint: String, CaseIterable {
        case pokemon
    }
    
    public enum PokeApiServiceError: Error {
        case apiError
        case invalidEndpoint
        case invalidResponse
        case noData
        case decodeError
    }
    
    private func fetchResources<T: Decodable>(url: URL, completion: @escaping (Result<T, PokeApiServiceError>) -> Void) {
        guard var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true) else {
            completion(.failure(.invalidEndpoint))
            return
        }
        
        let queryItems = [URLQueryItem(name: "limit", value: "100")]
        urlComponents.queryItems = queryItems
        
        guard let url = urlComponents.url else {
            completion(.failure(.invalidEndpoint))
            return
        }
        
        urlSession.dataTask(with: url){ (result) in
            switch result {
            case .success(let (response, data)):
                // print("success")
                guard let statusCode = (response as? HTTPURLResponse)?.statusCode, 200..<299 ~= statusCode else {
                    completion(.failure(.invalidResponse))
                    return
                }
                do {
                    let values = try self.jsonDecoder.decode(T.self, from: data)
                    completion(.success(values))
                } catch {
                    completion(.failure(.decodeError))
                }
            case .failure(let error):
                print(error)
                completion(.failure(.apiError))
            }
        }.resume()
    }
    
    public func fetchPokes(from endpoint: Endpoint, result: @escaping (Result<PokeCallResult, PokeApiServiceError>) -> Void) {
        let url = baseURL
            .appendingPathComponent(endpoint.rawValue)
        fetchResources(url: url, completion: result)
    }
}
