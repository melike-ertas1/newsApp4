//
//  RoundedImageView.swift
//  NewsApp
//
//  Created by melike ertaş on 8.12.2021.
//

import UIKit
import Alamofire

class RoundedImageView: UIImageView {

    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius = 6
        self.contentMode = .scaleAspectFill
        
    }
    
    var imageURLString: String?
    
    func load(urlString: String) {
        imageURLString = urlString
        self.image = nil
        
        if let imageFromCache = imageCache.object(forKey: urlString as AnyObject) as? UIImage {
            self.image = imageFromCache
            return
        }
        
        Alamofire.request(urlString).responseData { (response) in
            if response.error == nil {
                if let data =  response.data {
                    let imageToCache = UIImage(data: data )
                  
                    DispatchQueue.main.async {
                        if self.imageURLString ==   urlString {
                            self.image = imageToCache
                        }

                        if imageToCache != nil{
                          imageCache.setObject(imageToCache!, forKey: urlString as AnyObject)
                         }
                    }

                }
            }
        }
    }

}
