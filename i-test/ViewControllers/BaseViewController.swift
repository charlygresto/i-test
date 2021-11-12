//
//  BaseViewController.swift
//  i-test
//
//  Created by it on 12/11/2021.
//

import UIKit
import GoogleMobileAds

class BaseViewController: UIViewController, GADBannerViewDelegate {
    
    var bannerView: GADBannerView!
    var adsView:UIView!
    var adsViewAdded:Bool = false
    var closebtnIsVisible:Bool = false
    var closeButton:UIButton!
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        if !adsViewAdded{
            checkIfPaid()
        }
        
    }
    
    func checkIfPaid() {
        print("ads view added \(adsViewAdded)")
        
        if selectBy(serviceName: "GAD"){
            print("paid")
            adsView = UIView(frame: CGRect(x: 0, y: self.view.frame.height - 45, width: self.view.frame.width, height: 45))
        } else {
            adsView = UIView(frame: CGRect(x: 0, y: self.view.frame.height - 90, width: self.view.frame.width, height: 90))
            print("not paid")
            setupBannerView()
        }
        
        self.view.addSubview(adsView)
        adsView.backgroundColor = .black
        adsViewAdded = true
        
    }
    
    
    func setupBannerView(){
        
        bannerView = GADBannerView(adSize: GADAdSizeFromCGSize(CGSize(width: self.view.frame.width, height: 45)))
        
        bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
        
        bannerView.delegate = self
        
        bannerView.frame = CGRect(x: 0, y: adsView.frame.maxY - 45, width: self.view.frame.width, height: 45)
        
        self.view.addSubview(bannerView)
        
    }
    
    
    func bannerViewDidReceiveAd(_ bannerView: GADBannerView) {
        print("ad should show now")
        self.view.bringSubviewToFront(bannerView)
        if !closebtnIsVisible{
            addCloseButton()
        }
    }
    
    func bannerView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: Error) {
        print("failed to load ad \(error.localizedDescription)")
    }
    
    
    func addCloseButton(){
        closebtnIsVisible = true
        closeButton = UIButton()
        
        closeButton.setImage(UIImage(named: "cancel"), for: .normal)
        closeButton.setTitle("", for: .normal)
        closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        
        closeButton.frame = CGRect(x: self.view.frame.width - 23, y: self.bannerView.frame.minY - 5, width: 25, height: 25)
        
        self.view.addSubview(closeButton)
    }
    
    @objc func closeButtonTapped(sender: UIButton!) {
        print("Button tapped")
        
        let cancelAdAlert = UIAlertController(title: "Remove Ads?", message: "", preferredStyle: .alert)
        cancelAdAlert.addAction(UIAlertAction(title: "Pay", style: .default, handler: { _ in
            
            insertIntoDB(serviceName: "GAD", paid: true)
            
            self.bannerView.removeFromSuperview()
            self.closeButton.removeFromSuperview()
            
            self.adsViewAdded = false
            self.adsView.removeFromSuperview()
            self.checkIfPaid()
            
        }))
        cancelAdAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in
            
        }))
        
        self.present(cancelAdAlert, animated: true, completion: nil)
        
    }
}
