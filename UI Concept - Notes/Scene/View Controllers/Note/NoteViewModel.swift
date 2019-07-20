//
//  NoteViewModel.swift
//  UI Concept - Notes
//
//  Created by Suprianto Djamalu on 19/07/19.
//  Copyright © 2019 Suprianto Djamalu. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class NoteViewModel {
    
    var notes = BehaviorRelay<[Note]>(value: [])
    var message = BehaviorRelay<String>(value: "")
    
    func load(folderId: String){
        CoreDataNote.shared.load(folderId: folderId, {
            self.notes.accept($0)
        })
    }
    
    func delete(id: String){
        CoreDataNote.shared.delete(id: id) { (err) in
            if !err {
                self.message.accept("Note Deleted")
            }
        }
    }
    
    func search(key: String, folderId: String){
        CoreDataNote.shared.search(key: key, folderId: folderId) { (notes) in
            self.notes.accept(notes)
        }
    }
    
}
