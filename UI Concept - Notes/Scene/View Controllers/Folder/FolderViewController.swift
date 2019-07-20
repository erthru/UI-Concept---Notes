//
//  ViewController.swift
//  UI Concept - Notes
//
//  Created by Suprianto Djamalu on 18/07/19.
//  Copyright © 2019 Suprianto Djamalu. All rights reserved.
//

import UIKit
import RxSwift
import SnapKit

class FolderViewController: BaseViewController {

    private let tableFolder = UITableView()
    
    private let viewModel = FolderViewModel()
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        bindingViewModel()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        viewModel.load()
    }
    
    private func bindingViewModel(){
        viewModel.folders.subscribe({ folders in
            self.tableFolder.reloadData()
        }).disposed(by: disposeBag)
        
        viewModel.message.subscribe({ message in
            if message.element != "" {
                self.defaultAlert(msg: message.element!)
            }
        }).disposed(by: disposeBag)        
    }
    
    @objc fileprivate func btnRightNavOnTapped(){
        let alert = UIAlertController(title: "New Folder", message: "Enter a name for this folder", preferredStyle: .alert)
        alert.view.tintColor = .orange
        
        alert.addTextField(configurationHandler: { tf in
            tf.placeholder = "Name"
        })
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "Save", style: .default, handler: { action in
            if alert.textFields![0].text == ""{
                self.defaultAlert(msg: "Fill the name")
            }else{
                self.viewModel.create(name: alert.textFields![0].text!)
            }
        }))
        
        present(alert, animated: true)
    }
    
    private func updatePrepare(id: String, name: String){
        let alert = UIAlertController(title: "Edit Folder", message: "Edit name for this folder", preferredStyle: .alert)
        alert.view.tintColor = .orange
        
        alert.addTextField(configurationHandler: { tf in
            tf.placeholder = "Name"
            tf.text = name
        })
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "Save", style: .default, handler: { action in
            if alert.textFields![0].text == ""{
                self.defaultAlert(msg: "Fill the name")
            }else{
                self.viewModel.update(id: id, name: alert.textFields![0].text!)
            }
        }))
        
        present(alert, animated: true)
    }
    
    override func setupUI() {
        super.setupUI()
        // view
        view.addSubview(tableFolder)
        
        // navigation
        navigationItem.title = "Folders"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.searchController = searchBar
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.searchController?.searchBar.addSubview(NavigationUtil.navigationControllerLineView(view: view, navigationItem: navigationItem))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "New", style: .done, target: self, action: #selector(btnRightNavOnTapped))
        
        // searchBar
        searchBar.searchResultsUpdater = self
        
        // tableFolder
        tableFolder.snp.makeConstraints({ make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.equalTo(view.snp.leading)
            make.trailing.equalTo(view.snp.trailing)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        })
        tableFolder.tableFooterView = UIView()
        tableFolder.register(FolderCell.self, forCellReuseIdentifier: "FolderCell")
        tableFolder.delegate = self
        tableFolder.dataSource = self
    }
    
}

// MARK: Extensions
extension FolderViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.folders.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FolderCell") as! FolderCell
        cell.folder = viewModel.folders.value[indexPath.row]
        cell.accessoryType = .disclosureIndicator
        
        viewModel.totalNote(folderId: viewModel.folders.value[indexPath.row].id) { (total) in
            cell.noteTotal = total
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Delete", handler: { action, indexpath in
            self.viewModel.delete(id: self.viewModel.folders.value[indexPath.row].id)
        })
        
        let editAction = UITableViewRowAction(style: .normal, title: "Edit", handler: { action, indexpath in
            self.updatePrepare(id: self.viewModel.folders.value[indexPath.row].id, name: self.viewModel.folders.value[indexPath.row].name)
        })
        
        if indexPath.row != 0 {
            return [deleteAction,editAction]
        }
        
        return []
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = NoteViewController()
        vc.folderId = viewModel.folders.value[indexPath.row].id
        vc.name = viewModel.folders.value[indexPath.row].name
        
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension FolderViewController: UITableViewDelegate {}

extension FolderViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        if searchController.searchBar.text != "" {
            viewModel.search(key: searchController.searchBar.text!)
        }else{
            viewModel.load()
        }
    }
}

