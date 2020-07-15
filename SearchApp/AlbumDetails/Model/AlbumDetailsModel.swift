//
//  AlbumDetailsModel.swift
//  SearchApp
//
//  Created by Rajaram Mohanty on 15/07/20.
//  Copyright © 2020 Rajaram Mohanty. All rights reserved.
//

import Foundation


struct AlbumDetails: Codable {
    let album: AlbumInfo?
    
    private enum CodingKeys: String, CodingKey {
        case album
    }
}

extension AlbumDetails {
    init?(data: Data) {
        guard let me = try? JSONDecoder().decode(AlbumDetails.self, from: data) else { return nil }
        self = me
    }
}

struct AlbumInfo: Codable {
    let name,artist,url,listeners,mbid,playcount: String?
    let image:[Images]?
    let tracks:Track?
    let tags : Tags?
    let wiki : Wiki?
    

    private enum CodingKeys: String, CodingKey {
        case name,artist,url,listeners,mbid,playcount,image,tracks,tags,wiki
    }
}

struct Track: Codable {
    let track:[TrackInfo]?
    

    private enum CodingKeys: String, CodingKey {
        case track
    }
}

struct TrackInfo: Codable {
    let name,url,duration: String?
    let attr:Att?
    let streamable:Streamable?
    let tags : Artist?
    

    private enum CodingKeys: String, CodingKey {
        case name,url,duration,streamable,tags
        case attr = "@attr"
    }
}

struct Artist: Codable {
    let name,mbid,url: String?

    private enum CodingKeys: String, CodingKey {
        case name,mbid,url
    }
}

struct Att: Codable {
    let rank: String?

    private enum CodingKeys: String, CodingKey {
        case rank
    }
}

struct Streamable: Codable {
    let text,fulltrack: String?

    private enum CodingKeys: String, CodingKey {
        case text = "#text"
        case fulltrack
    }
}

struct Tags: Codable {
    let tag: [Tag]?

    private enum CodingKeys: String, CodingKey {
        case tag
    }
}


struct Tag: Codable {
    let name,url: String?

    private enum CodingKeys: String, CodingKey {
        case name,url
    }
}

struct Wiki: Codable {
    let published,summary,content: String?

    private enum CodingKeys: String, CodingKey {
        case published,summary,content
    }
}
