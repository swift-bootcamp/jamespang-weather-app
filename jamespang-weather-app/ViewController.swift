//
//  ViewController.swift
//  jamespang-weather-app
//
//  Created by JamesPang on 2014/8/16.
//  Copyright (c) 2014年 com.smart.h2. All rights reserved.
//

import UIKit

class ViewController: UIViewController, NSURLConnectionDataDelegate {
    
    var api: String = ""
    
    var data: NSMutableData = NSMutableData()
    
    
    @IBOutlet var city: UILabel!
    @IBOutlet var icon: UIImageView!
    @IBOutlet var temperature: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.city.text = "Taipei"
        self.icon.image = UIImage(named: "rain_0.jpg")
        
        startConnection()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func startConnection() {
        var restAPI: String = "http://api.openweathermap.org/data/2.5/weather?q=Taipei"
        var url: NSURL = NSURL(string: restAPI)
        var request: NSURLRequest = NSURLRequest(URL: url)
        var connection: NSURLConnection = NSURLConnection(request: request, delegate: self, startImmediately: true)
        
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
        let temp: AnyObject? = jsonDictionary["main"]?["temp"]
        
        // Data processing
        let weatherTempCelsius = Int(round((temp!.floatValue - 273.15)))
        let weatherFahrenheit = Int(round(((temp!.floatValue - 273.15) * 1.8 ) + 32 ))
        
        // Output to UI
        self.temperature.text = "\(weatherTempCelsius)"

    }
    // 下載完成
    func connectionDidFinishLoading(connection: NSURLConnection!) {
        println("Download finished")
        //var json = NSString(data: data, encoding: NSUTF8StringEncoding)

    }
    

}



