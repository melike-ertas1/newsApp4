//
//  NewsDetailViewController.swift
//  NewsApp
//
//  Created by melike ertaş on 7.12.2021.
//

import UIKit
import Firebase
import FirebaseCore
import FirebaseDatabase
import FirebaseCrashlytics
import FirebaseAnalytics

class NewsDetailViewController: UIViewController {

     @IBOutlet var newsImage: RoundedImageView!
     @IBOutlet var titleLabel: UILabel!
     @IBOutlet var authorName: UILabel!
     @IBOutlet var newsDate: UILabel!
     @IBOutlet var contentTextField: UITextView!
     @IBOutlet var sourceNewButton: UIButton!
     @IBOutlet var addFavoriteButton: UIBarButtonItem!
     @IBOutlet var shareButton: UIBarButtonItem!
     @IBOutlet var crashButton: UIButton!
    
    
    var ref:DatabaseReference!
    var newDetail:Article?
    var isFavorite: Bool = false
    let uid = UIDevice.current.identifierForVendor!.uuidString
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SetUI()
        ref = Database.database().reference()
    }
    
    func SetUI(){
        if isFavorite{
            self.addFavoriteButton.image = UIImage(systemName: "heart.fill")
        }
        if let newDetail = newDetail {
            titleLabel?.text = newDetail.title
            authorName?.text = newDetail.author
            if let imgURL = newDetail.urlToImage {
                newsImage?.load(urlString: imgURL)
            }
            else{
                newsImage?.image = UIImage(named: "defaultImage")
            }
            contentTextField?.text =  newDetail.articleDescription
            let date = DateConverter.convertDateFormater(newDetail.publishDate ?? "")
            newsDate?.text = date
        }
    }
    

    @IBAction func sourceNewsButtonAction(_ sender: Any) {
        let sourceVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SourceViewController") as! SourceViewController
        sourceVC.url = newDetail?.url
        navigationController?.pushViewController(sourceVC, animated: true)

        Analytics.logEvent("OpenSourceNews_Button_Click", parameters: nil)
    }
    

    @IBAction func addFavoriteButtonAction(_ sender: Any) {
        
        if isFavorite == false {
            self.addFavoriteButton.image = UIImage(systemName: "heart.fill")
            self.isFavorite = true
            if let newDetail = newDetail {
                let object:[String: Any] = [
                    "title": "\(newDetail.title ?? "")" as NSObject,
                    "description": "\(newDetail.articleDescription ?? "")" as NSObject,
                    "author": "\(newDetail.author ?? "")" as NSObject,
                    "urlToImage": "\(newDetail.urlToImage ?? "")" as NSObject,
                    "url": "\(newDetail.url ?? "")" as NSObject,
                    "publishDate": "\(newDetail.publishDate ?? "")" as NSObject,
                    "content": "\(newDetail.content ?? "")" as NSObject,
                    "isFavorite": "true"
                ]
                ref.child("articles").child("\(uid)").child("articles_\(Int.random(in: 0..<200))").setValue(object)
            }
        }
        Analytics.logEvent("Favorite_Button_Click", parameters: nil)
    }
    
    @IBAction func shareButtonAction(_ sender: Any) {

        if let newDetaill = self.newDetail {
            if let link = newDetaill.url
                {
                let objectsToShare = [link] as [Any]
                    if UIDevice.current.userInterfaceIdiom == .pad {
                            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
                            activityVC.excludedActivityTypes = []
                            activityVC.popoverPresentationController?.sourceView = self.view
                     }
                    let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
                    self.present(activityVC, animated: true, completion: nil)
                }
        }
        Analytics.logEvent("Share_Click", parameters: nil)
    }
    
//    FirebaseCrashlytics
    @IBAction func crashAction(_ sender: Any) {
        let numbers = [0]
        let _ = numbers[1]
        fatalError()
    }
}
