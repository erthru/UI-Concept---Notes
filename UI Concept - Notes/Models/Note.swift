//
//  Note.swift
//  UI Concept - Notes
//
//  Created by Suprianto Djamalu on 18/07/19.
//  Copyright © 2019 Suprianto Djamalu. All rights reserved.
//

import Foundation

struct Note {
    
    let id: String
    let body: String
    let createdAt: String
    let updatedAt: String
    let folderId: String
    
    func createdAtMin() -> String{
        return createdAt[0..<8].replace(target: "-", withString:"/")
    }
    
    func updatedAtMin() -> String{
        return updatedAt[0..<8].replace(target: "-", withString:"/")
    }
    
}
