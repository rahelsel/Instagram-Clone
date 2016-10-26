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

    static var originalImage = UIImage()
    
    class func filter(name: String, image: UIImage, completion: @escaping FilterCompletion){
        OperationQueue().addOperation {
            
            guard let filter = CIFilter(name: name) else { fatalError("Check Spelling of Filter Name.") }
            
            let ciImage = CIImage(image: image)
            
            filter.setValue(ciImage, forKey: kCIInputImageKey)
            
            let options = [kCIContextOutputColorSpace: NSNull()]
            let eaglContext = EAGLContext(api: .openGLES2)
            let context = CIContext(eaglContext: eaglContext!, options: options)
            
            guard let outputImage = filter.outputImage else { fatalError("Error retrieving output image from filter.") }
            
            guard let cgImage = context.createCGImage(outputImage, from: outputImage.extent) else { fatalError("Error Creating CGImage on GPU Context.") }
            
            OperationQueue.main.addOperation {
                completion(UIImage(cgImage: cgImage))
            }
            
        }
    
    }

    class Singleton {
    
        static let sharedInstance: Singleton = {
            let instance = Singleton()
            
            return instance
        }()
    }
    
    
    
//    class func vintage(image: UIImage, completion: @escaping FilterCompletion){
//        self.filter(name: "CIPhotoEffectTransfer", image: image, completion: completion)
//    }
//    
//    class func blackAndWhite(image: UIImage, completion: @escaping FilterCompletion){
//        self.filter(name: "CIPhotoEffectMono", image: image, completion: completion)
//    }
//
//    class func chrome(image: UIImage, completion: @escaping FilterCompletion){
//        self.filter(name: "CIPhotoEffectChrome", image: image, completion: completion)
//    }
//    
//    class func noir(image: UIImage, completion: @escaping FilterCompletion){
//        self.filter(name: "CIPhotoEffectNoir", image: image, completion: completion)
//    }
//
//    class func gaussianBlur(image: UIImage, completion: @escaping FilterCompletion){
//        self.filter(name: "CIGaussianBlur", image: image, completion: completion)
//    }

    
}
