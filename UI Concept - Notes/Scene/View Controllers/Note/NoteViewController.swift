//
//  NoteViewController.swift
//  UI Concept - Notes
//
//  Created by Suprianto Djamalu on 19/07/19.
//  Copyright © 2019 Suprianto Djamalu. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
import RxSwift

class NoteViewController: BaseViewController {
    
    private let tableNote = UITableView()
    
    var folderId: String!
    var name: String!
    
    private let viewModel = NoteViewModel()
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModelBinding()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.load(folderId: folderId)
    }
    
    private func viewModelBinding(){
        viewModel.notes.subscribe({ notes in
            self.tableNote.reloadData()
        }).disposed(by: disposeBag)
        
        viewModel.message.subscribe({ msg in
            if msg.element != "" {
                self.defaultAlert(msg: msg.element!)
                self.viewModel.load(folderId: self.folderId)
            }
        }).disposed(by: disposeBag)
    }
    
    @objc fileprivate func rightBtnNavTapped(){
        let vc = CreateNoteViewController()
        vc.folderId = folderId
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
    override func setupUI() {
        super.setupUI()
        // view
        view.addSubview(tableNote)
        
        // navigation
        navigationItem.title = name
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.searchController = searchBar
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "New", style: .done, target: self, action: #selector(rightBtnNavTapped))
        
        // searchBar
        searchBar.searchResultsUpdater = self
        
        // tableNote
        tableNote.snp.makeConstraints({ make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.equalTo(view.snp.leading)
            make.trailing.equalTo(view.snp.trailing)
            make.bottom.equalTo(view.snp.bottom)
        })
        tableNote.tableFooterView = UIView()
        tableNote.register(NoteCell.self, forCellReuseIdentifier: "NoteCell")
        tableNote.delegate = self
        tableNote.dataSource = self
    }
    
}

extension NoteViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.notes.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NoteCell") as! NoteCell
        cell.note = viewModel.notes.value[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexpath) in
            self.viewModel.delete(id: self.viewModel.notes.value[indexPath.row].id)
        }
        
        return [deleteAction]
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = CreateNoteViewController()
        vc.editMode = true
        vc.id = viewModel.notes.value[indexPath.row].id
        vc.body = viewModel.notes.value[indexPath.row].body
        
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension NoteViewController: UITableViewDelegate{}

extension NoteViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        if searchController.searchBar.text != ""{
            viewModel.search(key: searchController.searchBar.text!, folderId: folderId)
        }else{
            viewModel.load(folderId: folderId)
        }
    }
}
