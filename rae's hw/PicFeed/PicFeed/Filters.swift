//
//  Filters.swift
//  PicFeed
//
//  Created by Rachael A Helsel on 10/25/16.
//  Copyright © 2016 Rachael A Helsel. All rights reserved.
//

import UIKit

typealias FilterCompletion = (UIImage?)->()

class Filters{

    static let shared = Filters()
    
    static var originalImage = UIImage()
    
    let context : CIContext!
    
    private init(){
        let options = [kCIContextOutputColorSpace: NSNull()]
        let eaglContext = EAGLContext(api: .openGLES2)
        self.context = CIContext(eaglContext: eaglContext!, options: options)

    }
    
     func filter(name: String, image: UIImage, completion: @escaping FilterCompletion){
        OperationQueue().addOperation {
            
            guard let filter = CIFilter(name: name) else { fatalError("Check Spelling of Filter Name.") }
            
            let ciImage = CIImage(image: image)
            
            filter.setValue(ciImage, forKey: kCIInputImageKey)
            
                        guard let outputImage = filter.outputImage else { fatalError("Error retrieving output image from filter.") }
            
            guard let cgImage = Filters.shared.context.createCGImage(outputImage, from: outputImage.extent) else { fatalError("Error Creating CGImage on GPU Context.") }
            
            OperationQueue.main.addOperation {
                completion(UIImage(cgImage: cgImage))
            }
            
        }
    
    }

    func original(image: UIImage, completion: @escaping FilterCompletion){
        completion(Filters.originalImage)
        
    }
    
     func vintage(image: UIImage, completion: @escaping FilterCompletion){
        filter(name: "CIPhotoEffectTransfer", image: image, completion: completion)
    }
    
     func blackAndWhite(image: UIImage, completion: @escaping FilterCompletion){
        filter(name: "CIPhotoEffectMono", image: image, completion: completion)
    }

     func chrome(image: UIImage, completion: @escaping FilterCompletion){
        filter(name: "CIPhotoEffectChrome", image: image, completion: completion)
    }
    
     func noir(image: UIImage, completion: @escaping FilterCompletion){
        filter(name: "CIPhotoEffectNoir", image: image, completion: completion)
    }

     func gaussianBlur(image: UIImage, completion: @escaping FilterCompletion){
        filter(name: "CIGaussianBlur", image: image, completion: completion)
    }

    
}
