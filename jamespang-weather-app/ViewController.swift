//
//  ViewController.swift
//  jamespang-weather-app
//
//  Created by JamesPang on 2014/8/16.
//  Copyright (c) 2014年 com.smart.h2. All rights reserved.
//

import UIKit

class ViewController: UIViewController, NSURLConnectionDataDelegate, UITextFieldDelegate {
    
    var api: String = ""
    
    var data: NSMutableData = NSMutableData()
    
    var searchCity: String? = ""
    
    @IBOutlet var city: UILabel!
    @IBOutlet var icon: UIImageView!
    @IBOutlet var temperature: UILabel!
    @IBOutlet var weatherImg: UIImageView!
    
    @IBOutlet var searchBtn: UIButton?
    @IBOutlet var searchBtnImg: UIImage?
    @IBOutlet var editCity: UITextField?
    
    @IBOutlet var showCityName: UILabel!
    @IBOutlet var showTemperature: UILabel!
    @IBOutlet var goBtn: UIButton?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        println("viewDidLoad")
        // Do any additional setup after loading the view, typically from a nib.
        
        self.editCity!.hidden = true
        
        self.searchBtnImg = UIImage(named: "search1.jpg")
        self.searchBtn!.setImage(searchBtnImg, forState: UIControlState.Normal)
        self.goBtn!.addTarget(self, action: "onClick2:", forControlEvents: UIControlEvents.TouchUpInside)
        
        self.searchBtn!.addTarget(self, action: "onClick1:", forControlEvents: UIControlEvents.TouchUpInside)
        
        self.editCity!.addTarget(self, action: "textFieldDidBeginEditing:", forControlEvents: UIControlEvents.EditingDidBegin)
        self.editCity!.addTarget(self, action: "textFieldDidEndEditing:", forControlEvents: UIControlEvents.EditingDidEnd)
        
        //self.city.text = "Taipei"
        
        
        
        //startConnection()
    }
    
    func onClick1(sender: UIButton!) {
        self.editCity!.hidden = false
    }
    
    func onClick2(sender: UIButton!) {
        println("my city: " + self.editCity!.text)
        startConnection()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // 1. Delegation pattern
    // 2. NSURLConnection.sendAsynchronousRequest
    // 3. FP
    func startConnection() {
        println("startConnection")
        var city: String = self.editCity!.text
        println(city)
        var restAPI: String = "http://api.openweathermap.org/data/2.5/weather?q=\(city)"
        println(restAPI)
        var url: NSURL = NSURL(string: restAPI)
        var request: NSURLRequest = NSURLRequest(URL: url)
        var connection: NSURLConnection = NSURLConnection(request: request, delegate: self, startImmediately: true)
        
    }
    
    
    // 輸入中
    func textFieldDidBeginEditing(textField: UITextField!) {
        println("Editing...")
        self.searchCity = textField.text
        println(self.searchCity)
    }
    
    // 輸入完成
    func textFieldDidEndEditing(textField: UITextField!) {
        println("Edited")
        self.searchCity = textField.text
        println(self.searchCity)
        //startConnection()
    }
    
    // 下載中
    func connection(connection: NSURLConnection!, didReceiveData dataReceived: NSData!) {
        println("Downloading...")
        self.data.appendData(dataReceived)
        
        // 解析 JSON
        // 使用 NSDictionary: NSDictionary 是一種 Associative array 的資料結構
        var error: NSError?
        let jsonDictionary = NSJSONSerialization.JSONObjectWithData(self.data , options: NSJSONReadingOptions.MutableContainers, error: &error) as NSDictionary
        
        // Reading weather info
        let temp = jsonDictionary["main"]?["temp"]
        
        // Reading weather id
        let weather = jsonDictionary["weather"]? as NSArray
        if weather != nil/*let weather = jsonDictionary["weather"]? as? NSArray*/ {
            let weatherDictionary = (weather[0] as NSDictionary)
            let weatherID = weatherDictionary["id"] as Int
            println("Weather ID: \(weatherID)")
        }
        
        // Data processing
        let weatherTempCelsius = Int(round((temp!.floatValue - 273.15)))
        let weatherFahrenheit = Int(round(((temp!.floatValue - 273.15) * 1.8 ) + 32 ))
        
        // Output to UI
        self.showCityName.text = self.editCity!.text
        self.showTemperature.text = "\(weatherTempCelsius) "

    }
    // 下載完成
    func connectionDidFinishLoading(connection: NSURLConnection!) {
        println("Download finished")
        //var json = NSString(data: data, encoding: NSUTF8StringEncoding)

    }
    

}



