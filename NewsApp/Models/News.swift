//
//  News.swift
//  NewsApp
//
//  Created by melike ertaş on 8.12.2021.
//

import Foundation
import SwiftyJSON


struct Response {
    let status: String?
    let totalResults: Int?
    let articles: Article?
}

class Article {
    var status: String?
    var totalResults: Int?
    var author: String?
    var title: String?
    var articleDescription: String?
    var url: String?
    var urlToImage: String?
    var publishDate: String?
    var content: String?
    
   class func parseNews(from newsDict:JSON) -> Article {
       let news = Article()

       news.author = newsDict["author"].string
       news.title = newsDict["title"].string
       news.articleDescription = newsDict["description"].string
       news.url = newsDict["url"].string
       news.urlToImage = newsDict["urlToImage"].string
       news.publishDate = newsDict["publishedAt"].string
       news.content = newsDict["content"].string

       return news
   }
}



 



