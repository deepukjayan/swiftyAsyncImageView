//
//  AsyncImageView.swift
//  
//
//  Created by Deepak K on 6/1/15.
//  Copyright (c) 2015 Deepak. All rights reserved.
//

import Foundation
import UIKit

class AsyncImageView : UIImageView {
    
    
    func ImageUrl (url: NSURL){
        self.image = nil;//Just avoid the flickering effect
        if self.getImageFromLocal(url.absoluteString!) {
            return
        }
        
        downloadImage(url, handler: { (image, error) in
            if (error == nil){
                self.image = image
                self.saveLocally(image, key: url.absoluteString!)
            }else{
                self.image = nil //Error Occured, should we retry here again?
            }
        })
    }

    func downloadImage(url: NSURL, handler: ((image: UIImage, NSError!) -> Void)) {
        var imageRequest: NSURLRequest = NSURLRequest(URL: url)
        NSURLConnection.sendAsynchronousRequest(imageRequest,
            queue: NSOperationQueue.mainQueue(),
            completionHandler:{response, data, error in
                handler(image: UIImage(data: data)!, error)
        })
    }
    
    
    func saveLocally(image:UIImage, key:String){
        let documentsPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as! String
        let newKey = key.stringByReplacingOccurrencesOfString("/", withString: "-", options: NSStringCompareOptions.LiteralSearch, range: nil)
        let destinationPath = documentsPath.stringByAppendingPathComponent(newKey)
        UIImageJPEGRepresentation(image,1.0).writeToFile(destinationPath, atomically: true)
    }
    
    func getImageFromLocal(key:String) -> Bool{
        
        let fileManager = NSFileManager.defaultManager()
        var paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as! String
        let newKey = key.stringByReplacingOccurrencesOfString("/", withString: "-", options: NSStringCompareOptions.LiteralSearch, range: nil)
        var getImagePath = paths.stringByAppendingPathComponent(newKey)
        if (fileManager.fileExistsAtPath(getImagePath))
        {
            var theImage: UIImage = UIImage(contentsOfFile: getImagePath)!
            self.image = theImage
            return true
        }
        else
        {
            return false
        }

    }
    
}

