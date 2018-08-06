//
//  FlickerImageCell.swift
//  FlickrImages
//
//  Created by Sagar Pahwa on 15/07/18.
//  Copyright © 2018 Sagar Pahwa. All rights reserved.
//

import UIKit

class MovieImageCell: UICollectionViewCell {
    @IBOutlet weak var movieImageView: UIImageView!
    
    @IBOutlet weak var movieTitle: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.round()
    }
    
    func round(){
        self.layer.cornerRadius = 5
    }
    
    func loadImage(){
        
    }

}
