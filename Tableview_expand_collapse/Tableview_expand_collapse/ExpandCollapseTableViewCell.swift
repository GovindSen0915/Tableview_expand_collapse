//
//  ExpandCollapseTableViewCell.swift
//  Tableview_expand_collapse
//
//  Created by Nickelfox on 07/04/23.
//

import UIKit

protocol ExpandCollapseTableViewCellDeleagte: AnyObject {
    func didTapDropDownButton(for identifier: String, with isSelected: Bool, cellType: DummyCellType)
}

class ExpandCollapseTableViewCell: TableViewCell {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dropDownButton: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func configure(_ item: Any?) {
        guard let model = item as? ExpandCollapseTableCellModel else { return }
        self.nameLabel.text = model.name
        self.dropDownButton.setImage(model.dropDownImage, for: .normal)
        self.dropDownButton.isHidden = model.cellType == .floor
        
    }
    
    @IBAction func dropDownButtonAction(_ sender: UIButton) {
        if let item = self.item as? ExpandCollapseTableCellModel,
        let delegate = delegate as? ExpandCollapseTableViewCellDeleagte {
            delegate.didTapDropDownButton(for: item.identifier, with: item.isExpanded, cellType: item.cellType)
            self.dropDownButton.setImage(item.dropDownImage, for: .normal)
            item.isExpanded = !item.isExpanded
        }
    }

    
}

class ExpandCollapseTableCellModel {
    
    var index: Int
    var id: String
    var name: String
    var cellType: DummyCellType
    var isExpanded: Bool
    var childIndexPaths: [IndexPath] = []
    var identifier = ""
    init(index: Int, id: String, name: String, cellType: DummyCellType, isExpanded: Bool?) {
        self.index = index
        self.name = name
        self.id = id
        self.cellType = cellType
        self.isExpanded = isExpanded ?? false
    }
    
    var backgroundColor: UIColor {
        switch self.cellType {
        case .floor: return .yellow
        case .nurse: return .black
        case .shift: return .gray
            
        }
    }
    
    var textColor: UIColor {
        switch self.cellType {
        case .floor: return .black
        case .nurse: return .white
        case .shift: return .white
            
        }
    }
    
    var dropDownImage: UIImage {
        return self.isExpanded ? UIImage(systemName: "chevron.up")! : UIImage(systemName: "chevron.down")!
        
    }
    
    var contentHeightConstant: CGFloat {
        return self.isExpanded ? 60 : 0
        
    }
}

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
