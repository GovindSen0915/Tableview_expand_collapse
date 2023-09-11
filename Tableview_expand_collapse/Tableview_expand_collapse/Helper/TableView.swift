//
//  Tableview.swift
//  Tableview_expand_collapse
//
//  Created by Govind Sen on 11/09/23.
//

import UIKit


class TableViewCell: UITableViewCell {
    
    var item: Any? {
        didSet {
            self.configure(self.item)
        }
    }
    
    weak var delegate: NSObjectProtocol?
    
    func configure(_ item: Any?) {
        
    }
}
