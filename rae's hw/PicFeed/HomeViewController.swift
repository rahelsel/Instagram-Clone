//
//  HomeViewController.swift
//  PicFeed
//
//  Created by Rachael A Helsel on 10/24/16.
//  Copyright © 2016 Rachael A Helsel. All rights reserved.
//

import UIKit
import Social

class HomeViewController: UIViewController {
    
    var imagePicker = UIImagePickerController()
    @IBOutlet weak var imageView: UIImageView!
    
    
    @IBOutlet weak var filterButtonTopConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var postButtonTopConstraint: NSLayoutConstraint!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presentImagePicker(sourceType: .photoLibrary)
        
        if let galleryVC = self.tabBarController?.viewControllers?[1] as?
            GalleryViewController {
                galleryVC.delegate = self
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        filterButtonTopConstraint.constant = -100
        postButtonTopConstraint.constant = 100
        self.view.layoutIfNeeded()
        postButtonTopConstraint.constant = 25
        filterButtonTopConstraint.constant = 8
        
        UIView.animate(withDuration: 1.0) {
            self.view.layoutIfNeeded()
        }
    }
    
    func presentImagePicker(sourceType: UIImagePickerControllerSourceType){
        self.imagePicker.allowsEditing = true
        self.imagePicker.delegate = self
        self.imagePicker.sourceType = sourceType
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    func presentActionSheet(){
        
        let actionSheet = UIAlertController(title: "Source", message: "Select Source Type!!", preferredStyle: .actionSheet)
        
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { (action) in
            self.presentImagePicker(sourceType: .camera)
        }
        
        let photoLibraryAction = UIAlertAction(title: "Photo Library", style: .destructive) { (action) in
            
            self.presentImagePicker(sourceType: .photoLibrary)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        //  if the device doesn't have a camera, then it will just grey out the camera action button'
        if !UIImagePickerController.isSourceTypeAvailable(.camera){
            cameraAction.isEnabled = false
        }
        
        actionSheet.addAction(cameraAction)
        actionSheet.addAction(photoLibraryAction)
        actionSheet.addAction(cancelAction)
        
        self.present(actionSheet, animated: true, completion: nil)
        
    }

    @IBAction func imageLongPressed(_ sender: UILongPressGestureRecognizer) {
        guard let composeController = SLComposeViewController(forServiceType: SLServiceTypeTwitter) else { return }
        
        composeController.add(imageView.image)
        self.present(composeController, animated: true, completion: nil)
    }
    
    @IBAction func imageTapped(_ sender: AnyObject) {
        presentActionSheet()
    
    }

    @IBAction func postButtonPressed(_ sender: AnyObject) {
        
        if let image = imageView.image{
            let newPost = Post(image: image)
            
            API.shared.save(post: newPost, completion: { (success) in
                if success{
                    print("New Post was saved to CloudKit.")
                    
                    let selector = #selector(HomeViewController.image(_:didFinishSaving:context:))
                    
                    UIImageWriteToSavedPhotosAlbum(image, self, selector, nil)
                }
            
            })
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        if segue.identifier == FiltersPreviewController.identifier{
            if let filterController = segue.destination as? FiltersPreviewController{
                filterController.post = Post(image: self.imageView.image!)
                
                filterController.delegate = self //need this HERE for hw//
            }
        }
    
    }

    @IBAction func filterButtonPressed(_ sender: AnyObject) {
        
        guard let _ = self.imageView.image else { return }
        
        self.performSegue(withIdentifier: FiltersPreviewController.identifier, sender: nil)
        
//        let actionSheet = UIAlertController(title: "Filters", message: "Please Pick a Filter:", preferredStyle: .actionSheet)
//        
//        let bwAction = UIAlertAction(title: "Black & White", style: .default) { (action) in
//            Filters.shared.blackAndWhite(image: image, completion: { (filteredImage) in
//                self.imageView.image = filteredImage
//            })
//        }
//        
//        let chromeAction = UIAlertAction(title: "Chrome", style: .default) { (action) in
//            Filters.shared.chrome(image: image, completion: { (filteredImage) in
//                self.imageView.image = filteredImage
//            })
//        }
//
//        let vintageAction = UIAlertAction(title: "Vintage", style: .default) { (action) in
//            Filters.shared.chrome(image: image, completion: { (filteredImage) in
//                self.imageView.image = filteredImage
//            })
//        }
//        
//        let noirAction = UIAlertAction(title: "Noir", style: .default) { (action) in
//            Filters.shared.chrome(image: image, completion: { (filteredImage) in
//                self.imageView.image = filteredImage
//            })
//        }
//        
//        let gaussianBlurAction = UIAlertAction(title: "Gaussian Blur", style: .default) { (action) in
//            Filters.shared.chrome(image: image, completion: { (filteredImage) in
//                self.imageView.image = filteredImage
//            })
//        }
        
//        let resetAction = UIAlertAction(title: "Reset", style: .destructive) { (action) -> Void in
//            self.imageView.image = Filters.original
//        }
//       
//        actionSheet.addAction(bwAction)
//        actionSheet.addAction(chromeAction)
//        actionSheet.addAction(vintageAction)
//        actionSheet.addAction(noirAction)
//        actionSheet.addAction(gaussianBlurAction)
//        
//        self.present(actionSheet, animated: true, completion: nil)
        
    }

func image(_ image: UIImage, didFinishSaving error: NSError?, context: UnsafeRawPointer){
    if error == nil{
        let alert = UIAlertController(title: "Saved!", message: "Your Image was saved to your photos!", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        
        self.present(alert, animated: true, completion: nil)
    }
}
}
extension HomeViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let originalImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.dismiss(animated: true, completion: nil)
            imageView.image = originalImage
        }
        
        if let editedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            
            imageView.image = editedImage
            Filters.originalImage = editedImage
    
        }
    }
}


extension HomeViewController: FiltersPreviewControllerDelegate { //need this HERE for hw//
    
    func filtersPreviewController(selected: UIImage) {
        self.dismiss(animated: true, completion: nil)
        self.imageView.image = selected
    }

}

extension HomeViewController: GalleryViewControllerDelegate {
    
    func GalleryViewController(selected: UIImage) {
        
        self.imageView.image = selected
        self.tabBarController?.selectedViewController = self
    }

}

