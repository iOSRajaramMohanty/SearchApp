//
//  AlbumTableViewCell.swift
//  SearchApp
//
//  Created by Rajaram Mohanty on 15/07/20.
//  Copyright © 2020 Rajaram Mohanty. All rights reserved.
//

import UIKit
import AlamofireImage

class AlbumTableViewCell: UITableViewCell {
    static var Identifier = "AlbumTableViewCell"

    @IBOutlet weak var albumImagview: UIImageView!
    @IBOutlet weak var albumNameLbl: UILabel!{
        didSet{
            albumNameLbl.text = ""
        }
    }
    @IBOutlet weak var articlNameLbl: UILabel!{
        didSet{
            articlNameLbl.text = ""
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    var albumData: Album? {
        didSet {
          guard let albumData = albumData else { return }
            
            if let imageurl = albumData.image[0].text {
                albumImagview.af.setImage(withURL: URL(string: imageurl)!)
            }
            
            if let albumN = albumData.name {
                albumNameLbl.text = albumN
            }
            
            if let artistN = albumData.artist {
                articlNameLbl.text = artistN
            }
        }
    }
    
}
