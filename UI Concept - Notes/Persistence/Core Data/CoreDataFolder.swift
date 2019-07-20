//
//  CoreData.swift
//  UI Concept - Notes
//
//  Created by Suprianto Djamalu on 18/07/19.
//  Copyright © 2019 Suprianto Djamalu. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class CoreDataFolder {
    
    static let shared = CoreDataFolder()
    
    private var appDelegate: AppDelegate!
    private var managedContext: NSManagedObjectContext!
    
    private let ENTITY = "Folders"
    private let ID = "id"
    private let NAME = "name"
    private let CREATED_AT = "createdAt"
    private let UPDATED_AT = "updatedAt"
    
    init() {
        appDelegate = UIApplication.shared.delegate as? AppDelegate
        managedContext = appDelegate.persistentContainer.viewContext
        
        prepare()
    }
    
    private func prepare(){
        if !isExist(name: "Notes"){
            let entityFolder = NSEntityDescription.entity(forEntityName: ENTITY, in: managedContext)
            
            let folder = NSManagedObject(entity: entityFolder!, insertInto: managedContext)
            folder.setValue(UUID().uuidString, forKey: ID)
            folder.setValue("Notes", forKey: NAME)
            folder.setValue(Date(), forKey: CREATED_AT)
            folder.setValue(Date(), forKey: UPDATED_AT)
            
            try? managedContext.save()
        }
    }
    
    private func isExist(name: String) -> Bool{
        var exist = false
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>.init(entityName: ENTITY)
        fetchRequest.predicate = NSPredicate(format: "%K contains[c] %@", argumentArray:[NAME, name])
        
        let result = try? managedContext.fetch(fetchRequest)
        
        if result!.count > 0 {
            exist = true
        }
        
        return exist
    }
    
    func create(name: String, _ completion: @escaping (Bool) -> ()){
        if !isExist(name: name){
            let entityFolder = NSEntityDescription.entity(forEntityName: ENTITY, in: managedContext)
            
            let folder = NSManagedObject(entity: entityFolder!, insertInto: managedContext)
            folder.setValue(UUID().uuidString, forKey: ID)
            folder.setValue(name, forKey: NAME)
            folder.setValue(Date(), forKey: CREATED_AT)
            folder.setValue(Date(), forKey: UPDATED_AT)
            
            try? managedContext.save()
            completion(false)
        }else{
            completion(true)
        }
    }
    
    func load(_ completion: @escaping ([Folder]) -> ()){
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: ENTITY)
        
        let result = try? (managedContext.fetch(fetchRequest) as! [NSManagedObject])
        
        var folders = [Folder]()
        result!.forEach({
            folders.append(Folder(
                id: $0.value(forKey: ID) as! String,
                name: $0.value(forKey: NAME) as! String,
                createdAt: ($0.value(forKey: CREATED_AT) as! Date).toString(dateFormat: "dd-MM-yyyy"),
                updatedAt: ($0.value(forKey: UPDATED_AT) as! Date).toString(dateFormat: "dd-MM-yyyy")
            ))
        })
        
        completion(folders)
    }
    
    func update(id: String, name: String, _ completion: @escaping (Bool) -> ()){
        if !isExist(name: name){
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>.init(entityName: ENTITY)
            fetchRequest.predicate = NSPredicate(format: "%K contains[c] %@", argumentArray:[ID, id])
            
            let itemToUpdate = try? (managedContext.fetch(fetchRequest)[0] as! NSManagedObject)
            itemToUpdate?.setValue(name, forKey: NAME)
            itemToUpdate?.setValue(Date(), forKey: UPDATED_AT)
            
            try? managedContext.save()
            completion(false)
        }else{
            completion(true)
        }
    }
    
    func delete(id: String, _ completion: @escaping (Bool) -> ()){
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>.init(entityName: ENTITY)
        fetchRequest.predicate = NSPredicate(format: "%K contains[c] %@", argumentArray:[ID, id])
        
        let itemToDelete = try? (managedContext.fetch(fetchRequest)[0] as! NSManagedObject)
        managedContext.delete(itemToDelete!)
        
        try? managedContext.save()
        
        completion(false)
    }
    
    func search(key: String, completion: @escaping ([Folder]) -> ()){
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>.init(entityName: ENTITY)
        fetchRequest.predicate = NSPredicate(format: "%K contains[cd] %@", argumentArray:[NAME, key])
        
        let result = try? (managedContext.fetch(fetchRequest) as! [NSManagedObject])
        
        var folders = [Folder]()
        result!.forEach({
            folders.append(Folder(
                id: $0.value(forKey: ID) as! String,
                name: $0.value(forKey: NAME) as! String,
                createdAt: ($0.value(forKey: CREATED_AT) as! Date).toString(dateFormat: "dd-MM-yyyy"),
                updatedAt: ($0.value(forKey: UPDATED_AT) as! Date).toString(dateFormat: "dd-MM-yyyy")
            ))
        })
        
        completion(folders)
    }
    
}
