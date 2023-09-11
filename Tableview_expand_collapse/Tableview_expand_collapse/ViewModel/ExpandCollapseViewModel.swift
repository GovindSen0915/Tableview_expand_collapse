//
//  ExpandCollapseViewModel.swift
//  Tableview_expand_collapse
//
//  Created by Nickelfox on 07/04/23.
//

import Foundation

protocol ExpandCollapseViewModelDelegate: AnyObject {
    func reload()
    
}

class ExpandCollapseViewModel {
    
    weak var view: ExpandCollapseViewModelDelegate?
    var sectionModels = [SectionModel]()
    var cellModels = [Any]()
    
    var primaryIndexePaths: [IndexPath] = []
    var secondaryIndexePaths: [IndexPath] = []
    
    init(view: ExpandCollapseViewModelDelegate) {
        self.view = view
    }
    
    func prepareCellModel() {
        
        self.sectionModels = []
        self.cellModels = []
        var trackIndex = 0
        var dummyShift1CellsArray: [Any] = []
        var dummyFloor1CellsArray: [Any] = []
        let nurseIdentifier = "Nurse1"
        let dummyNurse1CellModel = ExpandCollapseTableCellModel(index: 0, id: "\(0)", name: "NURSE \(1)", cellType: .nurse, isExpanded: true)
        dummyNurse1CellModel.identifier = nurseIdentifier
        
        for index in 1..<4 {
            let shiftIdentifier = nurseIdentifier + "-Shift\(index)"
            
            let dummyShift1CellModel = ExpandCollapseTableCellModel(index: index, id: "\(index)", name: "Shift \(index)", cellType: .shift, isExpanded: false)
            dummyShift1CellModel.identifier = shiftIdentifier
            trackIndex += 1
            primaryIndexePaths.append(IndexPath(row: trackIndex, section: 0))
//            dummyShift1CellsArray.append(dummyCellModel)
            
            for index in 1..<4 {
                let floorIdentifier = shiftIdentifier + "-Shift\(index)"
                let dummyFloorCellModel = ExpandCollapseTableCellModel(index: index, id: "\(index)", name: "Floor \(index)", cellType: .floor, isExpanded: false)
                trackIndex += 1
                secondaryIndexePaths.append(IndexPath(row: trackIndex, section: 0))
                dummyFloorCellModel.identifier = floorIdentifier
                dummyFloor1CellsArray.append(dummyFloorCellModel)
            }
            
            primaryIndexePaths.append(contentsOf: secondaryIndexePaths)
            dummyShift1CellModel.childIndexPaths = secondaryIndexePaths
            secondaryIndexePaths = []
            dummyShift1CellsArray.append(dummyShift1CellModel)
            dummyShift1CellsArray.append(contentsOf: dummyFloor1CellsArray)
            dummyFloor1CellsArray = []
        }
        
        
        print("Floors: ", dummyFloor1CellsArray)
        print("Shifts: ", dummyShift1CellsArray)
//        print("Nurses: ", )
        dummyNurse1CellModel.childIndexPaths = primaryIndexePaths
        self.cellModels.append(dummyNurse1CellModel)
        self.cellModels.append(contentsOf: dummyShift1CellsArray)
        dummyShift1CellsArray = []
        print("Shifts: ", self.cellModels)
        self.sectionModels.append(SectionModel(cellModels: self.cellModels))
        self.view?.reload()
        
        
    }
    
}

extension ExpandCollapseViewModel: ExpandCollapseViewControllerDelegate {
    
    var numberOfSections: Int {
        return self.sectionModels.count
    }
    
    func itemAt(indexPath: IndexPath) -> Any {
        return self.sectionModels[indexPath.section].cellModels[indexPath.row]
    }
    
    func numberOfItemsAt(section: Int) -> Int {
        return self.sectionModels[section].cellModels.count
    }
    
    func setupData() {
        self.prepareCellModel()
    }
    
    func removeItem(for identifier: String, forCellType cellType: DummyCellType) {
        for cellModel in self.sectionModels.first?.cellModels ?? [] {
            if let model = cellModel as? ExpandCollapseTableCellModel,
               (model.identifier.localizedCaseInsensitiveContains(identifier) && model.identifier != identifier) {
                model.isExpanded = false
            }
        }
    }
    
    func addItem(for identifier: String, forCellType cellType: DummyCellType) {
        let totalCellModels = (self.sectionModels.first?.cellModels ?? []).filter({ (($0 as? ExpandCollapseTableCellModel)?.identifier ?? "").localizedCaseInsensitiveContains(identifier)})
        for cellModel in self.sectionModels.first?.cellModels ?? [] {
            if let model = cellModel as? ExpandCollapseTableCellModel,
               (model.identifier.localizedCaseInsensitiveContains(identifier) && model.identifier != identifier) {
                if cellType == .nurse {
                    if model.cellType == .shift {
                        model.isExpanded = true
                    }
                } else {
                    model.isExpanded = true
                }
            }
        }
    }
}

class SectionModel {
    var headerModel: Any?
    var cellModels: [Any]
    var footerModel: Any?
    
    init(headerModel: Any? = nil, cellModels: [Any], footerModel: Any? = nil) {
        self.headerModel = headerModel
        self.cellModels = cellModels
        self.footerModel = footerModel
    }
}

enum DummyCellType {
    case nurse, shift, floor
    
    var title: String {
        switch self {
        case .nurse:
            return "Nurse"
        case .shift:
            return "Morning Shift"
        case .floor:
            return "Floor 1"
        }
    }
}
