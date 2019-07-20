//
//  BaseController.swift
//  UI Concept - Notes
//
//  Created by Suprianto Djamalu on 18/07/19.
//  Copyright © 2019 Suprianto Djamalu. All rights reserved.
//

import Foundation
import UIKit

class BaseViewController: UIViewController{
    
    let searchBar = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    func defaultAlert(msg: String){
        let alert = UIAlertController(title: "Alert", message: msg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
        
        alert.view.tintColor = .orange
        
        present(alert, animated: true)
    }
    
    func setupUI(){
        // view
        view.backgroundColor = .white
        extendedLayoutIncludesOpaqueBars = true
        
        // navigation
        navigationController?.navigationBar.backgroundColor = .white
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.tintColor = .orange
        
        // searchBar
        searchBar.obscuresBackgroundDuringPresentation = false
        searchBar.searchBar.tintColor = .orange
        definesPresentationContext = true
    }
    
}
