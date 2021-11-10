//
//  ViewController.swift
//  i-test
//
//  Created by it on 10/11/2021.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var lblTimeUpdate: UILabel!
    @IBOutlet weak var lblDisclaimer: UILabel!
    
    @IBOutlet weak var pricesTableView: UITableView!
    
    var currencies:[Currency] = [Currency]()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
//        self.navigationController?.navigationBar.isHidden = true
        navigationController?.setNavigationBarHidden(true, animated: animated)
        
        lblDisclaimer.numberOfLines = 3
        lblDisclaimer.lineBreakMode = .byWordWrapping
        
        fetchData { currensys in
            self.currencies = currensys
            
            DispatchQueue.main.async {
                self.pricesTableView.reloadData()
            }
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    func fetchData( handler: @escaping ([Currency])->()) {
        
        currencies.removeAll()
        var temCurrenciesArr:[Currency] = [Currency]()
        
        let apiUrl:URL = URL(string: "https://api.coindesk.com/v1/bpi/currentprice.json")!
        
        URLSession.shared.dataTask(with: apiUrl) { (data, response, error) in
            
            if error != nil{
                print("error \(String(describing: error))")
            }else{
                do{
                    let json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! [String:Any]
                    
                    let time = json["time"] as! [String:String]
                    let updatedTime = time["updated"]

                    let disclaimer = json["disclaimer"] as! String

                    
                    DispatchQueue.main.async {
                        self.lblDisclaimer.text = disclaimer
                        self.lblTimeUpdate.text = updatedTime
                    }
                    
                    let bpi = json["bpi"] as! [String:[String:Any]]
                    
                    for currency in bpi {
                        let c = currency.value
                        
                        let code:String = c["code"] as! String
                        let symbol:String = c["symbol"] as! String
                        let rate:String = c["rate"] as! String
                        let desc:String = c["description"] as! String
                        
                        let mCurrency:Currency = Currency(code: code, symbol: symbol, rate: rate, desc: desc)
                        temCurrenciesArr.append(mCurrency)
                    }
                    
                } catch{
                    print(String(describing: error))
                }
                handler(temCurrenciesArr)
            }
            
            }.resume()
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.currencies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:CurrencyTableViewCell = pricesTableView.dequeueReusableCell(withIdentifier: CurrencyTableViewCell.reuseID) as! CurrencyTableViewCell
        let mCurrency:Currency = self.currencies[indexPath.row]
        
        cell.currencyDesc.text = mCurrency.desc
        cell.rate.text = mCurrency.rate
        
        return cell
    }
    
}

