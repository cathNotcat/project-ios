//
//  TableViewCell.swift
//  uts_c14210100
//
//  Created by Catherine Rosalind on 09/10/23.
//

import UIKit

class TableViewCell: UITableViewCell {

    @IBOutlet weak var serviceLabel: UILabel!
    
    @IBOutlet weak var hargaLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
