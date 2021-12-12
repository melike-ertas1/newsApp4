//
//  UIViewControlllerExtension.swift
//  NewsApp
//
//  Created by melike ertaş on 12.12.2021.
//

import Foundation
import UIKit

extension UIViewController {

    func showAlert(alertTitle: String,message: String){
        let alertTitle = "Upps!"
        let alert = UIAlertController(title:alertTitle , message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)

    }
}
