//
//  AlbumSearchVM.swift
//  SearchApp
//
//  Created by Rajaram Mohanty on 15/07/20.
//  Copyright © 2020 Rajaram Mohanty. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class AlbumSearchVM {
    
    public init() {}
    
    private let apiClient = APIClient()

    enum AlbumSearchError {
        case internetError(String)
        case serverMessage(String)
    }
    
    let albumList : PublishSubject<[Album]> = PublishSubject()
    let loading: PublishSubject<Bool> = PublishSubject()
    let error : PublishSubject<AlbumSearchError> = PublishSubject()
    var indexNo : Int = 0
    
    private let disposable = DisposeBag()
    
    
    func requestData(with name:String){
        self.loading.onNext(true)
        self.apiClient.send(apiRequest: AlbumSearchRequest(name: name), completion:{ (result)  in
               self.loading.onNext(false)
               switch result {
               case .success(let returnJson) :
                   guard let resultData = Results(data: try! returnJson.rawData()) else {
                       self.error.onNext(.serverMessage("Json parser Error"))
                       return
                   }
                   
                   let obj = resultData.results?.albummatches?.album
                   self.albumList.onNext(obj!)
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
