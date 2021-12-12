//
//  NewsAPIController.swift
//  NewsApp
//
//  Created by melike ertaş on 8.12.2021.
//

import Foundation
import Alamofire
import SwiftyJSON
import FirebaseAnalytics


class NewsAPIController: ApiController {
    
    class func getPopularNews(keyQuery:String,page:Int, completion:@escaping (_ result:APIResult<[Article]?, APIError>)->Void ){
        
        let query = keyQuery + "&page=\(page)"
        
        performRequest(endpoint:query, parameters: nil) { (res) in
            switch res {
            case .success(let json):
                let list = json["articles"].array
                let totalResult = json["totalResults"].int
                
                var newsList = [Article]()
                        list?.forEach({ (listDict) in
                            let news = Article.parseNews(from: JSON(rawValue: listDict) ?? JSON())
                            news.totalResults = totalResult
                            newsList.append(news)
                        })
               
                    completion(.success(newsList))
                
            case .failure(let err):
                completion(.failure(err))
                Analytics.logEvent(AnalyticsEventScreenView, parameters: [AnalyticsParameterScreenName: "NewsAPIController_Error"])
                Analytics.logEvent("Popular_News_Load_Error", parameters: nil)
                
            }
        }
    }
    
    
    class func searchNews(keyQuery:String,page:Int, completion:@escaping (_ result:APIResult<[Article]?, APIError>)->Void ){

        let query = keyQuery + "&page=\(page)"

        performRequest(endpoint:query, parameters: nil) { (res) in
            switch res {
            case .success(let json):
                let list = json["articles"].array
                let totalResult = json["totalResults"].int
                
                var newsList = [Article]()
                        list?.forEach({ (listDict) in
                            let news = Article.parseNews(from: JSON(rawValue: listDict) ?? JSON())
                            news.totalResults = totalResult
                            newsList.append(news)
                        })
               
                    completion(.success(newsList))
               
            case .failure(let err):
                completion(.failure(err))
                Analytics.logEvent("Search_News_Load_Error", parameters: nil)
            }
        }
    }
}
