//
//  LoadRemoteData.swift
//  Camping Consultant
//
//  Created by Jack N. Archer on 27/08/2016.
//  Copyright © 2016 Jack N. Archer. All rights reserved.
//

import Foundation
import UIKit

/// This class take in charge for all network communication happens within this application.
public class LoadRemoteData{
    /// The domain of our server, for easy configuration, is set here seperatly
    static let domain = "http://60.240.218.220:8080/"
    
    /// This function is used for fetching data from server by using specific api.
    /// - Parameters:
    ///     - api: The api WITHOUT domain, please refer to the api documents for more information
    ///     - type: Refers to the class that the loading will deal with.
    ///     - tableview: Refers to the UITableView that requires this connection. This parameter was required for reloading in async queue
    ///     - list: The array that will store the information about the result, either about temperature or about color
    ///     - failHandler: The function used to handle a connection error.
    static func loadData(api: String!, for type: String, in tableview: UITableView, into list: NSMutableArray, failHandler:(()->Void)?){
        // set the activitiy icon on
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        // set url
        let prepareURL = "\(domain)\(api!)".addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)
        let url = URL(string: prepareURL!)!
        print("GET \(url)")
        
        // set session
        let defaultSession = URLSession(configuration: URLSessionConfiguration.default)
        
        // data task for session
        var dataTask: URLSessionDataTask?
        dataTask = defaultSession.dataTask(with: url){
            data,respons, error in
            // async queue
            DispatchQueue.main.async{
                // error handler
                if let error = error{
                    print (error.localizedDescription)
                } else if let httpResponse = respons as? HTTPURLResponse {
                    print(httpResponse.statusCode)
                    if httpResponse.statusCode == 200{
                        // successufly got data
                        process(for: type, in: tableview, into: list, from: data)
                    } else{
                        // todo alert
                        failHandler?()
                    }
                }
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
            }
        }
        dataTask?.resume()
    }

    /// This function is used to process the data load from our server, to a valid JSON formmat
    /// Basicaly, this function will act as a compeletion handler for the communication function(implemented in the class LoadRemoteData.swift staticly)..
    /// - Parameters:
    ///     - data: The row JSON data
    ///     - type: Refers to the class that the loading will deal with.
    ///     - tableview: Refers to the UITableView that requires this connection. This parameter was required for reloading in async queue
    ///     - list: The array that will store the information about the result, either about temperature or about color
    static func process(for type: String, in tableView: UITableView, into list: NSMutableArray!, from data: Data!){
        
        do {
            guard
                let responsJSON = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions()) as? [String:AnyObject],
                // process the status data first.
                let status = responsJSON["status"] as? Int,
                let msg = responsJSON["msg"] as? String,
                let readings = responsJSON["sensorReadings"] as? NSArray
                else {
                    // TODO: handler for converting to json fails about response head
                    print("A response fails on converting")
                    return
            }
            if status == 0 || status == 1{
                // got readings
                if (type == "color"){
                    processColor(from: readings, into: list)
                } else if type == "temperature"{
                    processTemperature(from: readings, into: list)
                }
            } else {
                // no readings available
                print("Error:")
                print("Code: \(status)")
                print("Detail: \(msg)")
            }
            tableView.reloadData()
        } catch {
            print(error)
        }
    }
    
    /// This function is used to process the content of the response JSON to a color record. Then store it into local variable
    /// - Parameters:
    ///     - readings: An array that contains all results about color
    ///     - list: The array that will store the information about the result, either about temperature or about color
    static func processColor(from readings: NSArray!, into list: NSMutableArray!){
        
        for reading in readings{
            guard
                let reading = reading as? [String:AnyObject],
                let clear = reading["clear"] as? Double,
                let red = reading["red"] as? Double,
                let green = reading["green"] as? Double,
                let blue = reading["blue"] as? Double,
                let timestamp = reading["timestamp"] as? Int
                else {
                    // TODO: handler for converting to json fails about reading
                    print("A reading fails on converting")
                    return
            }
            list.add(ColorRecord(clear: clear/257, red: red/257, green: green/257, blue: blue/257, timeInterval: timestamp))
        }
        
    }
    
    /// This function is used to process the content of the response JSON to a temperature record. Then store it into local variable
    /// - Parameters:
    ///     - readings: An array that contains all results about temperature
    ///     - list: The array that will store the information about the result, either about temperature or about color
    static func processTemperature(from readings: NSArray!, into list:NSMutableArray!){
        for reading in readings{
            guard
                let reading = reading as? [String:AnyObject],
                let thermometer = reading["thermometer"] as? Float,
                let barometer = reading["barometer"] as? Float,
                let altimeter = reading["altimeter"] as? Float,
                let timestamp = reading["timestamp"] as? Int
                else {
                    // TODO: handler for converting to json fails about reading
                    print("A reading fails on converting")
                    return
            }
            list.add(TemperatureRecord(thermometer: thermometer, barometer: barometer, altimeter: altimeter, timeInterval: timestamp))
        }
        
    }
    
    static func processWeather(failHandler:(()->Void)?){
        // set the activitiy icon on
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        // set url
        let prepareURL = "http://api.openweathermap.org/data/2.5/weather?zip=3145,au&units=metric&appid=e2afc76bf0c3926204ced3218e372825".addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)
        let url = URL(string: prepareURL!)!
        print("GET \(url)")
        
        // set session
        let defaultSession = URLSession(configuration: URLSessionConfiguration.default)
        
        // data task for session
        var dataTask: URLSessionDataTask?
        dataTask = defaultSession.dataTask(with: url){
            data,respons, error in
            // async queue
            DispatchQueue.main.async{
                // error handler
                if let error = error{
                    print (error.localizedDescription)
                } else if let httpResponse = respons as? HTTPURLResponse {
                    print(httpResponse.statusCode)
                    if httpResponse.statusCode == 200{
                        // successufly got data
                        do {
                            guard
                                let responsJSON = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions()) as? [String:AnyObject],
                                let main = responsJSON["main"] as? [String: AnyObject],
                                let temperature = main["temp"] as? Float,
                                let airPressure = main["pressure"] as? Float else {return}
                            let webWeather = WebWeather(temperature: temperature, airPressure: airPressure/10)
                            print(webWeather.getDetailInString())
                        } catch {
                            print(error)
                        }

                    } else{
                        // todo alert
                        failHandler?()
                    }
                }
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
            }
        }
        dataTask?.resume()

    }
}
