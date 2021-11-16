//
//  ViewController.swift
//  i-test
//
//  Created by it on 10/11/2021.
//

import UIKit

class ViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var lblTimeUpdate: UILabel!
    @IBOutlet weak var pricesTableView: UITableView!
    
    
    var currencies:[Currency] = [Currency]()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: animated)
        
        fetchData { currensys in
            self.currencies = currensys
            
            DispatchQueue.main.async {
                self.pricesTableView.reloadData()
            }
        }
        
        pricesTableView.translatesAutoresizingMaskIntoConstraints = false

        pricesTableView.topAnchor.constraint(equalTo: self.lblTimeUpdate.bottomAnchor, constant: 20).isActive = true
        pricesTableView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        
        if adsView != nil{
            pricesTableView.bottomAnchor.constraint(equalTo: adsView.topAnchor, constant: 20).isActive = true
        } else{
            pricesTableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
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

                    DispatchQueue.main.async {
                        self.lblTimeUpdate.text = updatedTime
                    }
                    
                    let bpi = json["bpi"] as! [String:[String:Any]]
                    
                    for currency in bpi {
                        let c = currency.value
                        
                        let code:String = c["code"] as! String
                        let symbol:String = c["symbol"] as! String
                        let rate:String = c["rate"] as! String
                        let desc:String = c["description"] as! String
                        let rateFloat = c["rate_float"] as! Double
                        
                        let mCurrency:Currency = Currency(code: code, symbol: symbol, rate: rate, desc: desc, rate_float: rateFloat)
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
        cell.rate.text = mCurrency.rate_float.formatAsCurrency(currencyCode: mCurrency.code)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        let selectedBPI = currencies[indexPath.row]
        
        let sVC:SingleBPIViewController = storyboard?.instantiateViewController(identifier: "SingleBPIViewController") as! SingleBPIViewController
        
        sVC.currency = selectedBPI
        self.navigationController?.pushViewController(sVC, animated: true)
        
    }

    
}

