//
//  CurrencyTableViewCell.swift
//  i-test
//
//  Created by it on 10/11/2021.
//

import UIKit

class CurrencyTableViewCell: UITableViewCell {
    
    static var reuseID:String = "CurrencyTableViewCell"
    
    @IBOutlet weak var currencyDesc: UILabel!
    @IBOutlet weak var rate: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
