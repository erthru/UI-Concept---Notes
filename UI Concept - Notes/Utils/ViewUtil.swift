//
//  ViewUtil.swift
//  UI Concept - Notes
//
//  Created by Suprianto Djamalu on 18/07/19.
//  Copyright © 2019 Suprianto Djamalu. All rights reserved.
//

import Foundation
import UIKit

class NavigationUtil {
    
    static func navigationControllerLineView(view: UIView, navigationItem: UINavigationItem) -> UIView{
        let lineView = UIView(frame: CGRect(x: 0, y: (navigationItem.searchController?.searchBar.frame.height)! - 4, width: view.bounds.width, height: 1))
        lineView.backgroundColor = .white
        navigationItem.searchController?.searchBar.addSubview(lineView)
        return lineView
    }
    
}
