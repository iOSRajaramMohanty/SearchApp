//
//  AlbumDetailsRequest.swift
//  SearchApp
//
//  Created by Rajaram Mohanty on 15/07/20.
//  Copyright © 2020 Rajaram Mohanty. All rights reserved.
//

import Foundation
//ws.audioscrobbler.com/2.0/?method=album.getinfo&api_key=1c14c9cbfeefe394fc82097c496806f8&artist=System%20of%20a%20Down&album=Steal%20This%20Album!&format=json

class AlbumDetailsRequest: APIRequest {
    var api_Methods = "album.getinfo"
    var responseType = "json"
    var method = RequestType.GET
    var api_Virsion = "2.0/"
    var parameters = [URLQueryItem]()

    init(album_name: String,artist_name: String) {
        parameters.append(URLQueryItem(name: "album", value: album_name))
        parameters.append(URLQueryItem(name: "artist", value: artist_name))
    }
}
