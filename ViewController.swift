//
//  ViewController.swift
//  BitcoinTicker
//
//  Created by Angela Yu on 23/01/2016.
//  Copyright © 2016 London App Brewery. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    let baseURL = "https://apiv2.bitcoinaverage.com/indices/global/ticker/BTC"
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    let currencyIconArray = ["$", "R$", "$", "¥", "€", "£", "$", "Rp", "₪", "₹", "¥", "$", "kr", "$", "zł", "lei", "₽", "kr", "$", "$", "R"]
    
    var selectedIcon = ""
    
    var finalURL = ""

    //Pre-setup IBOutlets
    @IBOutlet weak var bitcoinPriceLabel: UILabel!
    @IBOutlet weak var currencyPicker: UIPickerView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        currencyPicker.delegate = self
        currencyPicker.dataSource = self
        
        getPriceData(currencySelected: currencyArray[0], icon: currencyIconArray[0])
        
        
    }

    
    
    //TODO: Place your 4 UIPickerView delegate methods here
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return currencyArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return currencyArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        getPriceData(currencySelected: currencyArray[row], icon: currencyIconArray[row])
        
    }

    
    func getPriceData(currencySelected : String, icon: String) {
        
        finalURL = baseURL + currencySelected
        
        Alamofire.request(finalURL).responseJSON {
            
            response in
            
            switch response.result {
            case .success:
                
                let currencyData : JSON = JSON(response.result.value!)
                let lastPrice = currencyData["ask"].double!
                self.updatePriceLabel(price: lastPrice, updateIcon: icon)
                
            case .failure(let error):
                print(error)
                
            }
        }
        
    }
    
    
    func updatePriceLabel(price: Double, updateIcon: String) {
        
        bitcoinPriceLabel.text =  updateIcon + " " + String((price*100).rounded()/100)
        
    }
    


}


