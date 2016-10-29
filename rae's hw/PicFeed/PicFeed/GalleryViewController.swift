//
//  GalleryViewController.swift
//  PicFeed
//
//  Created by Rachael A Helsel on 10/26/16.
//  Copyright © 2016 Rachael A Helsel. All rights reserved.
//

import UIKit

protocol GalleryViewControllerDelegate : class {

    func GalleryViewController(selected: UIImage)
}

class GalleryViewController: UIViewController {
    
    weak var delegate : GalleryViewControllerDelegate?

    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var allPosts = [Post](){
        didSet{
            collectionView.reloadData()
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = self
        collectionView.collectionViewLayout = GalleryCollectionViewLayout(columns: 3)
        

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        API.shared.getPosts { (posts) in
            if let posts = posts{
                self.allPosts = posts
            }
        }
    }
    
    @IBAction func userPinched(_ sender: UIPinchGestureRecognizer) {
        guard let layout = self.collectionView.collectionViewLayout as? GalleryCollectionViewLayout else { return }
        
        switch sender.state {
        case .ended:
            let columns = sender.velocity > 0 ? layout.columns - 1 : layout.columns + 1
            
            if columns < 1 || columns > 10 {
                return
            }
            
            UIView.animate(withDuration: 0.25, animations: {
                let newLayout = GalleryCollectionViewLayout(columns: columns)
                self.collectionView.setCollectionViewLayout(newLayout, animated: true)
            })
            
        default:
            return
        }
    }
    
}

extension GalleryViewController: UICollectionViewDataSource, UICollectionViewDelegate{

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let postCell = collectionView.dequeueReusableCell(withReuseIdentifier: GalleryCell.identifier(), for: indexPath) as! GalleryCell
        
        postCell.post = allPosts[indexPath.row]
        
        return postCell
        
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return allPosts.count
    
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let delegate = self.delegate else { return }
        
        let selectedCell = self.collectionView.cellForItem(at: indexPath) as! GalleryCell
        
        let selectedImage = selectedCell.post?.image
        
        delegate.GalleryViewController(selected: selectedImage!)
        
    }
    
}




