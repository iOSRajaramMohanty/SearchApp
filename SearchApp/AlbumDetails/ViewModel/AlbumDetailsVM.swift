//
//  AlbumDetailsVM.swift
//  SearchApp
//
//  Created by Rajaram Mohanty on 15/07/20.
//  Copyright © 2020 Rajaram Mohanty. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class AlbumDetailsVM {
    
    public init() {}
    
    private let apiClient = APIClient()

    enum AlbumDetailsError {
        case internetError(String)
        case serverMessage(String)
    }
    
    let albumDetails : PublishSubject<AlbumDetails> = PublishSubject()
    let loading: PublishSubject<Bool> = PublishSubject()
    let error : PublishSubject<AlbumDetailsError> = PublishSubject()
    var indexNo : Int = 0
    
    private let disposable = DisposeBag()
    
    
    func requestData(with albumName:String, artistName:String){
        self.loading.onNext(true)
        self.apiClient.send(apiRequest: AlbumDetailsRequest(album_name: albumName, artist_name: artistName), completion:{ (result)  in
               self.loading.onNext(false)
               switch result {
               case .success(let returnJson) :
                   guard let resultData = AlbumDetails(data: try! returnJson.rawData()) else {
                       self.error.onNext(.serverMessage("Json parser Error"))
                       return
                   }
                   
                   self.albumDetails.onNext(resultData)
               case .failure(let failure) :
                   switch failure {
                   case .connectionError:
                       self.error.onNext(.internetError("Check your Internet connection."))
                   case .authorizationError(let errorJson):
                       self.error.onNext(.serverMessage(errorJson["message"].stringValue))
                   default:
                       self.error.onNext(.serverMessage("Unknown Error"))
                   }
               case .successBool(_): break

               }
           })
    }
}
