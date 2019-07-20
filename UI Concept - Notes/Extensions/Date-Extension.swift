//
//  Date-Extension.swift
//  UI Concept - Notes
//
//  Created by Suprianto Djamalu on 18/07/19.
//  Copyright © 2019 Suprianto Djamalu. All rights reserved.
//

import Foundation

extension Date{
    
    func toString( dateFormat format  : String ) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
    
}
