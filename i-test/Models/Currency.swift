//
//  Currency.swift
//  i-test
//
//  Created by it on 10/11/2021.
//

import UIKit

class Currency: NSObject {
    
    var code:String
    var symbol:String
    var rate:String
    var desc:String
    var rate_float:Double
    
    init(code:String, symbol:String, rate:String, desc:String, rate_float:Double) {
        
        self.code = code
        self.symbol = symbol
        self.rate = rate
        self.desc = desc
        self.rate_float = rate_float
        
    }
    
}
