//
//  CreateNoteViewController.swift
//  UI Concept - Notes
//
//  Created by Suprianto Djamalu on 19/07/19.
//  Copyright © 2019 Suprianto Djamalu. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

class CreateNoteViewController: BaseViewController {
    
    private let txBody = UITextView()
    
    var editMode = false
    var id: String!
    var body: String!
    
    private let viewModel = CreateNoteViewModel()
    private let disposeBag = DisposeBag()
    
    var folderId: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModelBinding()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if editMode {
            txBody.text = body
        }
    }
    
    private func viewModelBinding(){
        viewModel.didSave.subscribe({ didSave in
            if didSave.element! {
                self.navigationController?.popViewController(animated: true)
            }
        }).disposed(by: disposeBag)
    }
    
    @objc fileprivate func rightBtnNavTapped(){
        if !editMode {
            if txBody.text != "" {
                viewModel.save(body: txBody.text, folderId: folderId)
            }else{
                navigationController?.popViewController(animated: true)
            }
        }else{
            if txBody.text != "" {
                viewModel.update(id: id, body: txBody.text)
            }else{
                navigationController?.popViewController(animated: true)
            }
        }
    }
    
    override func setupUI() {
        super.setupUI()
        // view
        view.addSubview(txBody)
        
        // navigation
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(rightBtnNavTapped))
        navigationItem.largeTitleDisplayMode = .never
        
        // txBody
        txBody.snp.makeConstraints({ make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(16)
            make.leading.equalTo(view.snp.leading).offset(16)
            make.trailing.equalTo(view.snp.trailing).offset(-16)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-16)
        })
        txBody.font = UIFont.systemFont(ofSize: 18)
        
    }
    
}
