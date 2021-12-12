//
//  FavoriteNewsViewController.swift
//  NewsApp
//
//  Created by melike ertaş on 7.12.2021.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAnalytics

class FavoriteNewsViewController: UIViewController {

    @IBOutlet var favoriteNewsTableView: UITableView!
    
    private var refreshControl = UIRefreshControl()
    let uid = UIDevice.current.identifierForVendor!.uuidString
    var ref: DatabaseReference!
    var favoriteNewsList = [Article]()
    var isFavorite:String?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference()
        SetUI()
        getFavoriteNews()

    }
    
    func SetUI(){
        favoriteNewsTableView.delegate = self
        favoriteNewsTableView.dataSource = self
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        favoriteNewsTableView.addSubview(refreshControl)
    }
    
    @objc func refresh() {
        getFavoriteNews()
        refreshControl.endRefreshing()
    }
    
    func  getFavoriteNews(){
        
        ref.child("articles").child("\(uid)").observe(.value, with: { [self] snapshot in

            if let result = snapshot.value as? [String: Any] {
                self.favoriteNewsList.removeAll()
                
                for new in result {
                    if let fav = new.value as? NSDictionary{

                        let favNew = Article()
                        favNew.content = fav["content"] as? String ?? ""
                        favNew.articleDescription = fav["description"]  as? String ?? ""
                        favNew.publishDate = fav["publishDate"] as? String ?? ""
                        favNew.title = fav["title"] as? String ?? ""
                        favNew.url = fav["url"]  as? String ?? ""
                        favNew.urlToImage = fav["urlToImage"] as? String ?? ""
                        favNew.author = fav["author"] as? String ?? ""
                        self.isFavorite = fav["isFavorite"] as? String
                        self.favoriteNewsList.append(favNew)
                    }
                 }
            }
            DispatchQueue.main.async {
                self.favoriteNewsTableView.reloadData()
            }

        })
        
    }
    

}


extension FavoriteNewsViewController: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoriteNewsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:FavoriteNewsTableViewCell = tableView.dequeueReusableCell(withIdentifier: "favoriteNewCell", for: indexPath) as! FavoriteNewsTableViewCell
        
        let newsList = self.favoriteNewsList[indexPath.row]
        
        cell.titleLabel.text = newsList.title
        cell.contentLabel.text = newsList.articleDescription
        
        if let imgURL = newsList.urlToImage {
            cell.newsImage?.load(urlString: imgURL)
        }
        else{
            cell.newsImage?.image = UIImage(named: "defaultImage")
        }
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let newsList = self.favoriteNewsList[indexPath.row]
        let detailVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "NewsDetailViewController") as! NewsDetailViewController
        detailVC.newDetail = newsList
        detailVC.isFavorite = true
        navigationController?.pushViewController(detailVC, animated: true)

        Analytics.logEvent("FavoritePage_News_Click", parameters: nil)
        
    }
    
}
