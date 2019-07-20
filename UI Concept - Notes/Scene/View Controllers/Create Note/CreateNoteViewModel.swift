//
//  CreateNoteViewModel.swift
//  UI Concept - Notes
//
//  Created by Suprianto Djamalu on 19/07/19.
//  Copyright © 2019 Suprianto Djamalu. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class CreateNoteViewModel {
    
    var didSave = BehaviorRelay<Bool>(value: false)
    
    func save(body: String, folderId: String){
        CoreDataNote.shared.create(body: body, folderId: folderId, {
            if !$0 {
                self.didSave.accept(true)
            }
        })
    }
    
    func update(id: String, body: String){
        CoreDataNote.shared.update(id: id, body: body) { (err) in
            if !err {
                self.didSave.accept(true)
            }
        }
    }
    
}
