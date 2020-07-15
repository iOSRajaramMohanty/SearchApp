//
//  APIClient.swift
//  SearchApp
//
//  Created by Rajaram Mohanty on 15/07/20.
//  Copyright © 2020 Rajaram Mohanty. All rights reserved.
//

import Foundation
import RxSwift
import SwiftyJSON

//http://ws.audioscrobbler.com/2.0/?method=album.search&album=Steal%20This%20Album!&api_key=1c14c9cbfeefe394fc82097c496806f8&format=json
enum ApiResult {
    case success(JSON)
    case successBool(Bool)
    case failure(RequestError)
}

enum RequestError: Error {
    case unknownError(String)
    case connectionError
    case authorizationError(JSON)
    case invalidRequest
    case notFound
    case invalidResponse
    case serverError
    case serverUnavailable
}

protocol APIServiceProtocol {
    func send(apiRequest: APIRequest, completion: @escaping (ApiResult)->Void)
}

class APIClient:APIServiceProtocol {
    private let baseURL = URL(string: "http://ws.audioscrobbler.com")!
    private let api_key = "1c14c9cbfeefe394fc82097c496806f8"


    func send(apiRequest: APIRequest, completion: @escaping (ApiResult)->Void) {
        let request = apiRequest.request(with: self.baseURL,with: self.api_key)
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            do {
                if let httpResponse = response as? HTTPURLResponse {
                    switch(httpResponse.statusCode)
                    {
                    case 200:
                        //2 . create a JSON object with data
                        let responseJson = try JSON(data: data ?? Data())
                        completion(ApiResult.success(responseJson))
                    default:
                        print("GET resquest not successful. http status code \(httpResponse.statusCode)")
                        completion(ApiResult.failure(.unknownError("GET resquest not successful. http status code \(httpResponse.statusCode)")))
                    }
                }
            } catch let error {
                completion(ApiResult.failure(.unknownError(error.localizedDescription)))
            }
        }
        task.resume()
        
    }
}
