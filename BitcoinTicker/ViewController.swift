//
//  ViewController.swift
//  BitcoinTicker


import UIKit
import Alamofire
import SwiftyJSON

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    let baseURL = "https://apiv2.bitcoinaverage.com/indices/global/ticker/BTC"
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    var finalURL = ""

    @IBOutlet weak var bitcoinPriceLabel: UILabel!
    @IBOutlet weak var currencyPicker: UIPickerView!

    override func viewDidLoad() {
        super.viewDidLoad()
        currencyPicker.dataSource = self
        currencyPicker.delegate = self
    }

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
        finalURL = baseURL + currencyArray[row]
        getCurrencyData(url: finalURL)
    }

    func getCurrencyData(url: String) {
        Alamofire.request(finalURL, method: .get)
            .responseJSON { response in
                if response.result.isSuccess {
                    print("Sucess")
                    let currency : JSON = JSON(response.result.value!)
                    self.updateCurrencyData(json: currency)
                } else {
                    print("Error: \(String(describing: response.result.error))")
                    self.bitcoinPriceLabel.text = "Connection Issues"
                }
            }
    }
    
    func updateCurrencyData(json : JSON) {
        
        if let currency = json["ask"].double {
            bitcoinPriceLabel.text = String(currency) + "$"
        }
        else {
            bitcoinPriceLabel.text = "Currency Unavailable"
        }
    }
}

