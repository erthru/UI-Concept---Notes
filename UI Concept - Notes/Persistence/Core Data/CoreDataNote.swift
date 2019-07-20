//
//  CoreDataNote.swift
//  UI Concept - Notes
//
//  Created by Suprianto Djamalu on 19/07/19.
//  Copyright © 2019 Suprianto Djamalu. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class CoreDataNote {
    
    static let shared = CoreDataNote()
    
    private var appDelegate: AppDelegate!
    private var managedContext: NSManagedObjectContext!
    
    private let ENTITY = "Notes"
    private let ID = "id"
    private let BODY = "body"
    private let CREATED_AT = "createdAt"
    private let UPDATED_AT = "updatedAt"
    private let FOLDER_ID = "folderId"
    
    init() {
        appDelegate = UIApplication.shared.delegate as? AppDelegate
        managedContext = appDelegate.persistentContainer.viewContext
    }
    
    func create(body: String, folderId: String, _ completion: @escaping(Bool) -> ()){
        let entity = NSEntityDescription.entity(forEntityName: ENTITY, in: managedContext)
        
        let note = NSManagedObject(entity: entity!, insertInto: managedContext)
        note.setValue(UUID().uuidString, forKey: ID)
        note.setValue(body, forKey: BODY)
        note.setValue(Date(), forKey: CREATED_AT)
        note.setValue(Date(), forKey: UPDATED_AT)
        note.setValue(folderId, forKey: FOLDER_ID)
        
        try? managedContext.save()
        completion(false)
    }
    
    func load(folderId: String, _ completion: ([Note]) -> ()){
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: ENTITY)
        fetchRequest.predicate = NSPredicate(format: "%K contains[c] %@", argumentArray: [FOLDER_ID, folderId])
        
        let result = try? (managedContext.fetch(fetchRequest) as! [NSManagedObject])
        
        var notes = [Note]()
        result?.forEach({
            notes.append(Note(
                id: $0.value(forKey: ID) as! String,
                body: $0.value(forKey: BODY) as! String,
                createdAt: ($0.value(forKey: CREATED_AT) as! Date).toString(dateFormat: "dd-MM-yyyy"),
                updatedAt: ($0.value(forKey: UPDATED_AT) as! Date).toString(dateFormat: "dd-MM-yyyy"),
                folderId: $0.value(forKey: FOLDER_ID) as! String
            ))
        })
        
        completion(notes)
    }
    
    func update(id: String, body: String, _ completion: @escaping(Bool) -> ()){
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>.init(entityName: ENTITY)
        fetchRequest.predicate = NSPredicate(format: "%K contains[c] %@", argumentArray: [ID, id])
        
        let itemToUpdate = try? (managedContext.fetch(fetchRequest)[0] as! NSManagedObject)
        itemToUpdate?.setValue(body, forKey: BODY)
        itemToUpdate?.setValue(Date(), forKey: UPDATED_AT)
        
        try? managedContext.save()
        completion(false)
    }
    
    func delete(id: String, _ completion: @escaping(Bool) -> ()){
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>.init(entityName: ENTITY)
        fetchRequest.predicate = NSPredicate(format: "%K contains[c] %@", argumentArray: [ID, id])
        
        let itemToDelete = try? (managedContext.fetch(fetchRequest)[0] as! NSManagedObject)
        managedContext.delete(itemToDelete!)
        
        try? managedContext.save()
        
        completion(false)
    }
    
    func search(key: String, folderId: String, completion: @escaping ([Note]) -> ()){
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>.init(entityName: ENTITY)
        fetchRequest.predicate = NSPredicate(format: "%K contains[cd] %@ AND %K contains[c] %@", argumentArray:[BODY, key, FOLDER_ID, folderId])

        let result = try? (managedContext.fetch(fetchRequest) as! [NSManagedObject])
        
        var notes = [Note]()
        result?.forEach({
            notes.append(Note(
                id: $0.value(forKey: ID) as! String,
                body: $0.value(forKey: BODY) as! String,
                createdAt: ($0.value(forKey: CREATED_AT) as! Date).toString(dateFormat: "dd-MM-yyyy"),
                updatedAt: ($0.value(forKey: UPDATED_AT) as! Date).toString(dateFormat: "dd-MM-yyyy"),
                folderId: $0.value(forKey: FOLDER_ID) as! String
            ))
        })
        
        completion(notes)
    }
    
}
