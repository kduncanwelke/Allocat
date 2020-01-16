//
//  EntryTableViewCell.swift
//  Allocat
//
//  Created by Kate Duncan-Welke on 1/16/20.
//  Copyright © 2020 Kate Duncan-Welke. All rights reserved.
//

import UIKit

class EntryTableViewCell: UITableViewCell {
    
    // MARK: IBOutlets
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
