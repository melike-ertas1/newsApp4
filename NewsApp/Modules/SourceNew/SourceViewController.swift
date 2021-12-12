//
//  SourceViewController.swift
//  NewsApp
//
//  Created by melike ertaş on 7.12.2021.
//

import UIKit
import WebKit

class SourceViewController: UIViewController {
    let webView = WKWebView()
    var url: String? = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(webView)
        
        guard let url = URL(string: url ?? "" ) else {
            return
        }
        webView.load(URLRequest(url: url))
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        webView.frame = view.bounds
    }

}
