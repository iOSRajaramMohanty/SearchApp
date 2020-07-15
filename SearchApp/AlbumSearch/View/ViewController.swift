//
//  ViewController.swift
//  SearchApp
//
//  Created by Rajaram Mohanty on 15/07/20.
//  Copyright © 2020 Rajaram Mohanty. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import AlamofireImage


class ViewController: UIViewController {

    private let tableView = UITableView()
    private let cellIdentifier = "AlbumTableViewCell"

    var albumSearchVM = AlbumSearchVM()
    let disposeBag = DisposeBag()
    
    private let searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.placeholder = "Search for Album"
        return searchController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureProperties()
        configureLayout()
        self.setupBindings()
    }

    private func configureProperties() {
        let nib = UINib(nibName: AlbumTableViewCell.Identifier, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: AlbumTableViewCell.Identifier)
        navigationItem.searchController = searchController
        navigationItem.title = "Album finder"
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationController?.navigationBar.prefersLargeTitles = true
    }

    private func configureLayout() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        tableView.contentInset.bottom = view.safeAreaInsets.bottom
    }
    
    private func setupBindings() {
        // binding loading to vc
        albumSearchVM.loading.bind(to: self.rx.isAnimating).disposed(by: disposeBag)
        
        // observing errors to show
        albumSearchVM
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
        
        // binding albums to album container
        albumSearchVM.albumList.bind(to: tableView.rx.items(cellIdentifier: AlbumTableViewCell.Identifier, cellType: AlbumTableViewCell.self)) { index, model, cell in
            cell.albumData = model
        }.disposed(by: disposeBag)
        
        searchController.searchBar.rx.text.asObservable()
            .map { ($0 ?? "").lowercased() }
            .subscribe(onNext: { homeDetail in
                self.albumSearchVM.requestData(with: homeDetail)
            })
            .disposed(by: disposeBag)
        
        tableView.rx.modelSelected(Album.self)
            .subscribe(onNext: { album in
                guard let vc = self.storyboard?.instantiateViewController(identifier: "AlbumDetailsVC", creator: { coder in
                    return AlbumDetailsVC(coder: coder, selectedUser: album)
                }) else {
                    fatalError("Failed to load EditUserViewController from storyboard.")
                }
                self.navigationController?.pushViewController(vc, animated: true)
            })
            .disposed(by: disposeBag)
    }
}

