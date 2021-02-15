//
//  Cell.swift
//  CoreDataOperations
//
//  Created by MAC on 15/02/21.
//

import UIKit

class Cell: UITableViewCell {

    @IBOutlet weak var first: UILabel!
    @IBOutlet weak var second: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
