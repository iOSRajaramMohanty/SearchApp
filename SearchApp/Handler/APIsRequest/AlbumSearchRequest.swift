//
//  AlbumSearchRequest.swift
//  SearchApp
//
//  Created by Rajaram Mohanty on 15/07/20.
//  Copyright © 2020 Rajaram Mohanty. All rights reserved.
//

import Foundation

class AlbumSearchRequest: APIRequest {
    var api_Methods = "album.search"
    var responseType = "json"
    var method = RequestType.GET
    var api_Virsion = "2.0/"
    var parameters = [URLQueryItem]()

    init(name: String) {
        parameters.append(URLQueryItem(name: "album", value: name))
    }
}
