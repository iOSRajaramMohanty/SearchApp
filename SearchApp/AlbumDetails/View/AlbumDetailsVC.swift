//
//  AlbumDetailsVC.swift
//  SearchApp
//
//  Created by Rajaram Mohanty on 15/07/20.
//  Copyright © 2020 Rajaram Mohanty. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class AlbumDetailsVC: UIViewController {

    var albumObj: Album
    
    var albumDetailsVM = AlbumDetailsVM()
    let disposeBag = DisposeBag()
    
    init?(coder: NSCoder, selectedUser: Album) {
        self.albumObj = selectedUser
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        debugPrint(albumObj)
        self.setupBindings()
    }
    
    private func setupBindings() {
        // binding loading to vc
        albumDetailsVM.loading.bind(to: self.rx.isAnimating).disposed(by: disposeBag)
        
        // observing errors to show
        albumDetailsVM
            .error
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { (error) in
                switch error {
                case .internetError(_):break
                    //MessageView.sharedInstance.showOnView(message: message, theme: .error)
                case .serverMessage(_):break
                    //MessageView.sharedInstance.showOnView(message: message, theme: .warning)
                }
            })
           .disposed(by: disposeBag)
        
        albumDetailsVM
            .albumDetails
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { (details) in
                debugPrint(details)
            })
            .disposed(by: disposeBag)
    }
    
}
