//
//  ViewController.swift
//  i-test
//
//  Created by it on 10/11/2021.
//

import UIKit
import GoogleMobileAds

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, GADBannerViewDelegate {
    
    
    @IBOutlet weak var lblTimeUpdate: UILabel!
//    @IBOutlet weak var lblDisclaimer: UILabel!
    @IBOutlet weak var closeAd: UIButton!
    
    @IBOutlet weak var pricesTableView: UITableView!
    
    @IBOutlet weak var gadView: GADBannerView!
    
    
    var currencies:[Currency] = [Currency]()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: animated)
        
//        lblDisclaimer.numberOfLines = 3
//        lblDisclaimer.lineBreakMode = .byWordWrapping
        
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        gadView.adUnitID = "ca-app-pub-4807549148849980/5977710321"
        gadView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        gadView.rootViewController = self
        gadView.load(GADRequest())
        
        gadView.delegate = self
        
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

//                    let disclaimer = json["disclaimer"] as! String

                    
                    DispatchQueue.main.async {
//                        self.lblDisclaimer.text = disclaimer
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
    
    
    @IBAction func closeAds(_ sender: Any) {
        
        let cancelAdAlert = UIAlertController(title: "Remove Ads?", message: "", preferredStyle: .alert)
//        cancelAdAlert.title = "Remove Ads?"
//        cancelAdAlert.message = "All data will be lost."
        cancelAdAlert.addAction(UIAlertAction(title: "Pay", style: .default, handler: { _ in
            
        }))
        cancelAdAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in
            
        }))
        
        self.present(cancelAdAlert, animated: true, completion: nil)
        
    }
    
    
    func bannerViewDidReceiveAd(_ bannerView: GADBannerView) {
        self.gadView.bringSubviewToFront(self.closeAd)
    }
    
}

