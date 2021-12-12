//
//  NewsViewController.swift
//  NewsApp
//
//  Created by melike ertaş on 7.12.2021.
//

import UIKit
import FirebaseCrashlytics
import FirebaseAnalytics

class NewsViewController: UIViewController, UISearchControllerDelegate {


    @IBOutlet var newsTableView: UITableView!
 
    //Pagination Variables
    private var currentPage = 1
    private var isLastPage = false
    private var isInProgress = false
    //----------------------
    
    private var refreshControl = UIRefreshControl()
    private let searchVC = UISearchController(searchResultsController: nil)
    var newList:Array<Article> = []
    var isSearch:Bool = false
    var searchText:String?
    var totalResult:Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SetUI()
        getPopularNews(page: currentPage)
    }
    
    func SetUI(){
        createSearchBar()
        newsTableView.delegate = self
        newsTableView.dataSource = self
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        newsTableView.addSubview(refreshControl)
    }

    @objc func refresh() {
        currentPage = 1
        if isSearch{
            searchNews(text:self.searchText!, page: currentPage)
        }
        else{
            getPopularNews(page: currentPage)
        }
        refreshControl.endRefreshing()
    }
    
    private func createSearchBar(){
        navigationItem.searchController = searchVC
        searchVC.searchBar.delegate = self
        searchVC.searchBar.tintColor = .white
    }

    
    func getPopularNews(page: Int){
        isInProgress = true
        NewsAPIController.getPopularNews(keyQuery: "turkey",page: page) { (result) in
          switch result {
            case .success(let newsList):
                    if newsList != nil{
                              self.isInProgress = false
                              self.isLastPage = newsList?.count == 0

                              if newsList?.count ?? 0 > 0  {
                                  if self.currentPage == 0 {
                                      self.newList = newsList ?? []
                                  } else {
                                      self.newList += newsList ?? []
                                  }
                                     DispatchQueue.main.async {
                                         self.newsTableView.reloadData()
                                     }
                                }
                    }
                    else{
                        let message = "Sorry, couldn't find the news you were looking for."
                        self.showAlert(alertTitle: "", message: message)
                    }

            case .failure(let err):
            self.showAlert(alertTitle: "", message: err.message)
            Analytics.logEvent("Popular_API_Error", parameters: nil)
              
            break
              }

        }
    }
    
    func searchNews(text:String, page: Int){
        isInProgress = true
        let textReplace = ReplaceHelper.replaceTurkishCharacter(text: text)
        
        NewsAPIController.searchNews(keyQuery: textReplace, page: page) { (result) in
            switch result {
               case .success(let newsList):
                if page > 1 && newsList?.isEmpty == true{
                   return
                }
                
                if newsList?.isEmpty == false {
                    if newsList != nil{
                                self.isInProgress = false
                                self.isLastPage = newsList?.count == 0

                                if newsList?.count ?? 0 > 0  {
                                    if self.currentPage == 0 {
                                        self.newList = newsList ?? []
                                    } else {
                                        self.newList += newsList ?? []
                                    }
                                       DispatchQueue.main.async {
                                           self.newsTableView.reloadData()
                                           self.searchVC.dismiss(animated: true, completion: nil)
                                       }
                                }
                            }
                        }

                      else{
                          let message = "Sorry, couldn't find the news you were looking for."
                          self.showAlert(alertTitle: "", message: message)
                          DispatchQueue.main.async {
                              self.newsTableView.reloadData()
                              self.searchVC.dismiss(animated: true, completion: nil)
                          }
                      }

                case .failure(let err):
                self.showAlert(alertTitle: "", message: err.message)
                Analytics.logEvent("Search_API_Error", parameters: nil)
                break
                }
        }
    }

}

extension NewsViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:NewsTableViewCell = tableView.dequeueReusableCell(withIdentifier: "newsCell", for: indexPath) as! NewsTableViewCell
        let newsList = self.newList[indexPath.row]
        
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
        let newsList = self.newList[indexPath.row]
        let detailVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "NewsDetailViewController") as! NewsDetailViewController
        detailVC.newDetail = newsList
        navigationController?.pushViewController(detailVC, animated: true)

        Analytics.logEvent("HomePage_News_Click", parameters: nil)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let bottomEdge = scrollView.contentSize.height - (scrollView.contentOffset.y + scrollView.frame.size.height)
        if bottomEdge <= scrollView.frame.size.height && !isLastPage && !isInProgress {
            currentPage += 1
           
            if isSearch{
                searchNews(text: self.searchText ?? "", page: currentPage)
            }
            else{
                getPopularNews(page: currentPage)
            }
        }
    }

}

extension NewsViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        Analytics.logEvent("Search_NavButton_Click", parameters: nil)
        guard let searchText = searchBar.text, !searchText.isEmpty else {
            return
        }
        self.newList.removeAll()
        self.isSearch = true
        self.searchText = searchText
        searchNews(text: searchText, page: 1)
    }
}

