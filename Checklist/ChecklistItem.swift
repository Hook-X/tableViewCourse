//
//  ChecklistItem.swift
//  Checklist
//
//  Created by Hook Banner on 15.03.2022.
//

import Foundation


class ChecklistItem: NSObject {
    var text = ""
    var checked = false
    
    func toggleChecked() {
      checked = !checked
    }
}
