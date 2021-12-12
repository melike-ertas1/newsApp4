//
//  DateConverter.swift
//  NewsApp
//
//  Created by melike ertaş on 12.12.2021.
//

import Foundation
import UIKit

class DateConverter{

    class func convertDateFormater(_ date: String) -> String
        {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss z"
            let date = dateFormatter.date(from: date)
            dateFormatter.dateFormat = "dd-MM-yyyy"
            return  dateFormatter.string(from: date ?? Date())
        }
}
