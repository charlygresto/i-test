//
//  SingleBPIViewController.swift
//  i-test
//
//  Created by it on 10/11/2021.
//

import UIKit

class SingleBPIViewController: UIViewController {
    
    
    @IBOutlet weak var lblCurrencyDesc: UILabel!
    @IBOutlet weak var lblCurrencyRate: UILabel!
    
    var currency:Currency!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.lblCurrencyDesc.text = currency.desc
        
        let formattedRate = currency.rate_float.formatAsCurrency(currencyCode: currency.code)
        
        self.lblCurrencyRate.text = formattedRate
        
    }
    
}
