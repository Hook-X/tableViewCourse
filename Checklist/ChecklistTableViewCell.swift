//
//  ChecklistTableViewCell.swift
//  Checklist
//
//  Created by Hook Banner on 18.03.2022.
//

import UIKit

class ChecklistTableViewCell: UITableViewCell {
    @IBOutlet weak var checkMarkLabel: UILabel!
    @IBOutlet weak var todoTextLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
