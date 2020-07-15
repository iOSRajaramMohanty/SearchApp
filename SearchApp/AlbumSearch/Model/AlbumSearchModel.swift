//
//  AlbumSearchModel.swift
//  Networking with RxSwift
//
//  Created by Rajaram Mohanty on 15/07/20.
//  Copyright © 2020 Maciej Matuszewski. All rights reserved.
//

import Foundation

struct Results: Codable {
    let results: AlbumSearchModel?

    private enum CodingKeys: String, CodingKey {
        case results = "results"
    }
}

extension Results {
    init?(data: Data) {
        guard let me = try? JSONDecoder().decode(Results.self, from: data) else { return nil }
        self = me
    }
}

struct AlbumSearchModel: Codable {
    let opensearch: Query?
    let totalResults,startIndex,itemsPerPage: String?
    let albummatches: Albummatches?
    let attr: Attr?

    private enum CodingKeys: String, CodingKey {
        case opensearch = "opensearch:Query"
        case totalResults = "opensearch:totalResults"
        case startIndex = "opensearch:startIndex"
        case itemsPerPage = "opensearch:itemsPerPage"
        case attr = "@attr"
        case albummatches
    }
}

struct Query: Codable {
    let text,role,searchTerms,startPage: String?

    private enum CodingKeys: String, CodingKey {
        case text = "#text"
        case role,searchTerms,startPage
    }
}

struct Attr: Codable {
    let attrfor: String?

    private enum CodingKeys: String, CodingKey {
        case attrfor = "for"
    }
}

struct Albummatches: Codable {
    let album: [Album]

    private enum CodingKeys: String, CodingKey {
        case album
    }
}

struct Album: Codable {
    let name,artist,url,streamable,mbid: String?
    let image:[Images]

    private enum CodingKeys: String, CodingKey {
        case name,artist,url,streamable,mbid, image
    }
}

struct Images: Codable {
    let size,text: String?

    private enum CodingKeys: String, CodingKey {
        case text = "#text"
        case size
    }
}
