//
//  NetworkClient.swift
//  FlickrGalleryAssignment
//
//  Created by Donovan Söderlund on 2020-04-07.
//  Copyright © 2020 Future Memories. All rights reserved.
//

import Foundation

protocol JSONDecoderProtocol {
    func decode<T: Decodable>(_ data: Data) -> T?
}

protocol URLRequestConvertible {
    var urlRequest: URLRequest { get }
}

protocol URLRequestContent {
    var host: String { get }
    var path: String { get }
    var method: String { get }
    var headers: [String : String]? { get }
    var parameters: [String : String]? { get }
    var body: Data? { get }
}

typealias Route = URLRequestContent & URLRequestConvertible

enum NetworkClientError: Error {
    case noData
    case decodingError
}

class NetworkClient {
    
    private let urlSession: URLSession
    private let jsonDecoder: JSONDecoderProtocol
    
    static let shared = NetworkClient()
    
    required init(urlSession: URLSession = .shared, jsonDecoder: JSONDecoderProtocol = JSONDecoder()) {
        self.urlSession = urlSession
        self.jsonDecoder = jsonDecoder
    }
    
    func perform<T: Decodable>(_ requestConvertible: URLRequestConvertible, completion: @escaping (_ result: Result<T, NetworkClientError>) -> ()) {
        perform(requestConvertible.urlRequest, completion: completion)
    }
    
    func perform<T: Decodable>(_ route: Route, completion: @escaping (_ result: Result<T, NetworkClientError>) -> ()) {
        perform(route as URLRequestConvertible, completion: completion)
    }
    
    func perform<T: Decodable>(_ request: URLRequest, completion: @escaping (_ result: Result<T, NetworkClientError>) -> ()) {
        print("Sending request: \(request)")
        urlSession.dataTask(with: request) { [weak self] data, response, error in
            guard let self = self else { return }
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(.failure(.noData))
                }
                return
            }
            guard let value: T = self.jsonDecoder.decode(data) else {
                DispatchQueue.main.async {
                    completion(.failure(.decodingError))
                }
                return
            }
            DispatchQueue.main.async {
                completion(.success(value))
            }
        }.resume()
    }
    
}

extension JSONDecoder: JSONDecoderProtocol {
    
    func decode<T: Decodable>(_ data: Data) -> T? {
        do {
            return try decode(T.self, from: data)
        } catch {
            print(error)
            return nil
        }
    }
    
}

extension URLRequestConvertible where Self: Route {
    
    var urlRequest: URLRequest {
        let parametersString = createParametersString()
        var request = URLRequest(url: URL(string: host + path + parametersString)!)
        request.httpMethod = method
        for header in (headers ?? [:]) {
            request.addValue(header.value, forHTTPHeaderField: header.key)
        }
        request.httpBody = body
        return request
    }
    
    private func createParametersString() -> String {
        #error("Set your Flickr API key and then remove this line")
        let baseParameters = [
            "api_key" : "API_KEY",
            "format" : "json",
            "nojsoncallback" : "1",
            "extras" : "url_m,url_l"
        ]
        let allParameters = parameters?.merging(baseParameters) { old, _ in old } ?? baseParameters
        let joinedParameters = allParameters
            .map { "\($0.key)=\($0.value)" }
            .joined(separator: "&")
        return "?\(joinedParameters)"
    }
    
}
