//
//  FiltersPreviewController.swift
//  PicFeed
//
//  Created by Rachael A Helsel on 10/27/16.
//  Copyright © 2016 Rachael A Helsel. All rights reserved.
//

import UIKit

protocol FiltersPreviewControllerDelegate : class { //need this HERE for hw//
    
    func filtersPreviewController(selected: UIImage)
}

class FiltersPreviewController: UIViewController {
    
    weak var delegate : FiltersPreviewControllerDelegate? //need this HERE for hw//

        @IBOutlet weak var collectionView: UICollectionView!
    
    let filters = [Filters.shared.original, Filters.shared.blackAndWhite, Filters.shared.chrome, Filters.shared.vintage]
    
    var post = Post()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.collectionView.collectionViewLayout = GalleryCollectionViewLayout(columns: 2)
    }

}


extension FiltersPreviewController{
    static var identifier: String{
        return String(describing: self)
    }
    
}


extension FiltersPreviewController: UICollectionViewDataSource, UICollectionViewDelegate{
        
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let filterCell = collectionView.dequeueReusableCell(withReuseIdentifier: GalleryCell.identifier(), for: indexPath) as! GalleryCell
            
            let filter = self.filters[indexPath.row]
            
            filter(self.post.image) { (filteredImage) in
                filterCell.cellImageView.image = filteredImage
            }
           
            return filterCell
        }
    
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return filters.count
        }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let delegate = self.delegate else { return }
        
        let filter = self.filters[indexPath.row]
        
        filter(self.post.image) { (filteredImage) in
            if let filteredImage = filteredImage{
                delegate.filtersPreviewController(selected: filteredImage) //need this HERE for hw//
            }
        }
    }
}

