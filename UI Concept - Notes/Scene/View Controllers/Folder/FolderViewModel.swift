//
//  FolderViewModel.swift
//  UI Concept - Notes
//
//  Created by Suprianto Djamalu on 19/07/19.
//  Copyright © 2019 Suprianto Djamalu. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class FolderViewModel {
    
    var folders = BehaviorRelay<[Folder]>(value: [])
    var message = BehaviorRelay<String>(value: "")
    
    func create(name: String){
        CoreDataFolder.shared.create(name: name, {
            if $0 {
                self.message.accept("Folder Exist")
            }else{
                self.message.accept("Folder Created")
                self.load()
            }
        })
    }
    
    func load(){
        CoreDataFolder.shared.load({
            self.folders.accept($0)
        })
    }
    
    func delete(id: String){
        CoreDataFolder.shared.delete(id: id, {
            if $0 {
                self.message.accept("Failed to Delete Folder. Try Again")
            }else {
                self.message.accept("Folder Deleted")
                self.load()
            }
        })
    }
    
    func update(id: String, name: String){
        CoreDataFolder.shared.update(id: id, name: name, {
            if $0 {
                self.message.accept("Folder Exist")
            }else{
                self.message.accept("Folder Updated")
                self.load()
            }
        })
    }
    
    func search(key: String){
        CoreDataFolder.shared.search(key: key, completion: {
            self.folders.accept($0)
        })
    }
    
    func totalNote(folderId: String, _ completion: @escaping (Int) -> ()){
        CoreDataNote.shared.load(folderId: folderId, {
            completion($0.count)
        })
    }
    
}
