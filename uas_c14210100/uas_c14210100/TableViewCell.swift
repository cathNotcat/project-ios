//
//  TableViewCell.swift
//  uas_c14210100
//
//  Created by Catherine Rosalind on 03/12/23.
//

import UIKit

class TableViewCell: UITableViewCell {
    
    
  
    @IBOutlet weak var card: UITableViewCell!
    
    @IBOutlet weak var nama: UILabel!
    
    @IBOutlet weak var email: UILabel!
    
    @IBOutlet weak var notelp: UILabel!
    
    @IBOutlet weak var perusahaan: UILabel!
    
    @IBOutlet weak var web: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
