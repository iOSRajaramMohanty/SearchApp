//
//  APIClientTestsCase.swift
//  SearchAppTests
//
//  Created by Rajaram Mohanty on 15/07/20.
//  Copyright © 2020 Rajaram Mohanty. All rights reserved.
//

import XCTest
@testable import SearchApp
@testable import SwiftyJSON

class APIClientTestsCase: XCTestCase {

    var sutt: APIClient?
    
    override func setUp() {
        super.setUp()
        sutt = APIClient()
    }
    
    override func tearDown() {
        sutt = nil
        super.tearDown()
    }

    func test_fetch_albums() {

        // Given A apiservice
        let sutt = self.sutt!

        // When fetch popular photo
        let expect = XCTestExpectation(description: "callback")

        sutt.send(apiRequest: AlbumSearchRequest(name: "ind"), completion:{ (result) in
            expect.fulfill()
            switch result {
                case .success(let returnJson) :
                    guard let resultData = Results(data: try! returnJson.rawData()) else {
                        return
                    }
                    XCTAssertEqual( resultData.results?.albummatches?.album.count, 50)
                    if let albums = resultData.results?.albummatches?.album {
                        for alb in albums {
                            XCTAssertNotNil(alb.mbid)
                        }
                    }
                case .failure(let failure) :
                    switch failure {
                    case .connectionError: break
                    case .authorizationError( _): break
                    default: break
                    }
                case .successBool(_): break
            }
        })

        wait(for: [expect], timeout: 3.1)
    }
}
