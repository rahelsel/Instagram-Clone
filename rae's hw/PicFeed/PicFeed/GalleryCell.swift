//
//  GalleryCell.swift
//  PicFeed
//
//  Created by Rachael A Helsel on 10/26/16.
//  Copyright © 2016 Rachael A Helsel. All rights reserved.
//

import UIKit

class GalleryCell: UICollectionViewCell {
    
    @IBOutlet weak var cellImageView: UIImageView!
    
    var post : Post? {
        didSet{
            self.cellImageView.image = post?.image
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.cellImageView.image = nil
    }
    
}

extension GalleryCell{
    
    class func identifier() -> String{
        return String(describing: self)
    }
}
