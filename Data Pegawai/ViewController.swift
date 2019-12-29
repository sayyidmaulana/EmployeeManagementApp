//
//  ViewController.swift
//  Data Pegawai
//
//  Created by sayyid maulana khakul yakin on 29/12/19.
//  Copyright © 2019 sayyid maulana khakul yakin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let searchController = UISearchController(searchResultsController: nil)

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    func setupView() {
        self.navigationController?.navigationBar.prefersLargeTitles = true
        searchController.hidesNavigationBarDuringPresentation = true
        searchController.searchBar.placeholder = "Find Employees"
        
        tableView.tableHeaderView = searchController.searchBar
        
        self.navigationItem.title = "Employees"
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 0.14, green: 0.86, blue: 0.73, alpha: 1.0)
        self.navigationController?.navigationBar.tintColor = .white
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        self.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
    }
}

