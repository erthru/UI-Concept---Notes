//
//  FolderCell.swift
//  UI Concept - Notes
//
//  Created by Suprianto Djamalu on 18/07/19.
//  Copyright © 2019 Suprianto Djamalu. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

class FolderCell: BaseCell {
    
    private let lbName = UILabel()
    private let lbTotal = UILabel()
    
    var folder: Folder? {
        didSet{
            lbName.text = folder?.name
        }
    }
    
    var noteTotal: Int? {
        didSet {
            lbTotal.text = "\(noteTotal!)"
        }
    }
    
    override func setupUI() {
        super.setupUI()
        
        // view
        self.contentView.addSubview(lbName)
        self.addSubview(lbTotal)
        
        // lbName
        lbName.snp.makeConstraints({ make in
            make.leading.equalTo(self.snp.leading).offset(16)
            make.trailing.equalTo(lbTotal.snp.leading).offset(-16)
            make.centerY.equalTo(self.snp.centerY)
        })
        lbName.text = "name"
        
        // lbTotal
        lbTotal.snp.makeConstraints({ make in
            make.trailing.equalTo(self.snp.trailing).offset(-40)
            make.centerY.equalTo(self.snp.centerY)
        })
        lbTotal.text = "0"
    }
    
}
