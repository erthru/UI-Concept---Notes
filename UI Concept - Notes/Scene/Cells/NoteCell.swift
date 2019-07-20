//
//  NoteCell.swift
//  UI Concept - Notes
//
//  Created by Suprianto Djamalu on 19/07/19.
//  Copyright © 2019 Suprianto Djamalu. All rights reserved.
//

import Foundation
import UIKit

class NoteCell: BaseCell {
    
    private let lbTitle = UILabel()
    private let lbDesc = UILabel()
    
    var note: Note! {
        didSet{
            lbTitle.text = note.body
            lbDesc.text = note.updatedAtMin()
        }
    }
    
    override func setupUI() {
        super.setupUI()
        
        // view
        self.addSubview(lbTitle)
        self.addSubview(lbDesc)
        
        // lbTitle
        lbTitle.snp.makeConstraints({ make in
            make.centerY.equalTo(self.snp.centerY).offset(-14)
            make.leading.equalTo(self.snp.leading).offset(16)
            make.top.equalTo(self.snp.top).offset(10)
        })
        lbTitle.font = UIFont.boldSystemFont(ofSize: 20)
        
        // lbDesc
        lbDesc.snp.makeConstraints({ make in
            make.centerY.equalTo(self.snp.centerY).offset(14)
            make.leading.equalTo(self.snp.leading).offset(16)
            make.bottom.equalTo(self.snp.bottom).offset(-10)
        })
        lbDesc.textColor = .gray
    }
    
}
