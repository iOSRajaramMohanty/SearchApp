//
//  APIRequest.swift
//  SearchApp
//
//  Created by Rajaram Mohanty on 15/07/20.
//  Copyright © 2020 Rajaram Mohanty. All rights reserved.
//


import Foundation

public enum RequestType: String {
    case GET, POST, PUT, PATCH, DELETE, TRACE, CONNECT, HEAD, OPTIONS
}

protocol APIRequest {
    var method: RequestType { get }
    var api_Virsion: String { get }
    var responseType: String { get }
    var parameters: [URLQueryItem] { get }
    var api_Methods: String { get }
}

extension APIRequest {
    func request(with baseURL: URL, with ApiKey: String) -> URLRequest {
        
        guard var components = URLComponents(url: baseURL.appendingPathComponent(api_Virsion), resolvingAgainstBaseURL: false) else {
            fatalError("Unable to create URL components")
        }

        let queryItems = [URLQueryItem(name: "method", value: api_Methods),URLQueryItem(name: "api_key", value: ApiKey), URLQueryItem(name: "format", value: responseType)] + parameters
        components.queryItems = queryItems
        
        guard let url = components.url else {
            fatalError("Could not get url")
        }


        var request = URLRequest(url: url)//.appendingPathComponent(parameters))
        request.httpMethod = method.rawValue
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        return request
    }
}
