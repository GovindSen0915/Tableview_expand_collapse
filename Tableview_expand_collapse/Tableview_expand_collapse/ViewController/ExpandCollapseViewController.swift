//
//  ViewController.swift
//  Tableview_expand_collapse
//
//  Created by Nickelfox on 07/04/23.
//

import UIKit

protocol ExpandCollapseViewControllerDelegate: AnyObject {
    var numberOfSections: Int { get }
    func numberOfItemsAt(section: Int) -> Int
    func itemAt(indexPath: IndexPath) -> Any
    func setupData()
    
    func removeItem(for identifier: String, forCellType cellType: DummyCellType)
    func addItem(for identifier: String, forCellType cellType: DummyCellType)
    
}

class ExpandCollapseViewController: UIViewController {
    
    @IBOutlet weak var tableview: UITableView!
    
    var viewModel: ExpandCollapseViewControllerDelegate!
    var cellType: DummyCellType = .nurse
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupTableView()
        self.setupViewModel()
        self.viewModel.setupData()
    }
    
    private func setupViewModel() {
        self.viewModel = ExpandCollapseViewModel(view: self)
    }
    
    
}

extension ExpandCollapseViewController: ExpandCollapseViewModelDelegate {
    func reload() {
        self.tableview.reloadData()
    }
    
}

extension ExpandCollapseViewController: UITableViewDelegate, UITableViewDataSource {
    
    private func setupTableView() {
        self.tableview.delegate = self
        self.tableview.dataSource = self
        self.tableview.registerCell(ExpandCollapseTableViewCell.self)
        self.tableview.separatorStyle = .none
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.viewModel.numberOfSections
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.numberOfItemsAt(section: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: "ExpandCollapseTableViewCell") as? ExpandCollapseTableViewCell else {
            return UITableViewCell()
        }
        
        cell.item = self.viewModel.itemAt(indexPath: indexPath)
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if let item = self.viewModel.itemAt(indexPath: indexPath) as? ExpandCollapseTableCellModel {
            if item.cellType == .nurse {
                return 60
            } else {
                if item.cellType == .shift && self.cellType == .shift {
                    return 60
                } else {
                    if item.isExpanded {
                        return 60
                    } else{
                        return 0
                    }
                }
            }
            
        } else {
            return 0
        }
    }
}

extension ExpandCollapseViewController: ExpandCollapseTableViewCellDelegate {
    func didTapDropDownButton(for identifier: String, with isExpanded: Bool, cellType: DummyCellType) {
        self.cellType = cellType
        if isExpanded {
            self.viewModel.addItem(for: identifier, forCellType: cellType)
        } else {
            self.viewModel.removeItem(for: identifier, forCellType: cellType)
        }
        
        UIView.animate(withDuration: 0.3) {
            self.tableview.performBatchUpdates(nil)
        }
    }
}




