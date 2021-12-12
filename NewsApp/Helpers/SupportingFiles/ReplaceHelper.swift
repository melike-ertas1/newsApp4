//
//  ReplaceHelper.swift
//  NewsApp
//
//  Created by melike ertaş on 12.12.2021.
//

import Foundation
import UIKit

class ReplaceHelper{
    
    class func replaceTurkishCharacter(text:String?) -> String{
        
        let mutableString = NSMutableString(string: text!) as CFMutableString
        CFStringTransform(mutableString, nil, kCFStringTransformStripCombiningMarks,  Bool(truncating: 0))

        var normalized = (mutableString as NSMutableString).copy() as! NSString
        normalized = normalized.replacingOccurrences(of: " ", with: "%20") as NSString
        normalized = normalized.replacingOccurrences(of: "ı", with: "i") as NSString
        return normalized as String

    }
}
