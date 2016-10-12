//
//  Record.swift
//  ContactMySensors
//
//  Created by Jack N. Archer on 11/10/2016.
//  Copyright © 2016 Jack N. Archer. All rights reserved.
//

protocol DisplayableRecord {
    /// This function is used to generated a String format of the detailed info
    /// Returns: A String that contains all detailed info for the temperature record in multiple lines
    func getDetailInString() -> String!
    
    ///This method is used to get a fomatted date time in String.
    ///- Returns: Date & time for the date before today, and only time for today, in the String format.
    func getFormattedTime() -> String
    
    /// This function is used to get a generated array, which contains all the detail information that will be displayed
    /// on the detail view. The detail view in our design would also be a table view, so it would be better
    /// to store all the information by an array.
    /// - Returns: An array that contains all detail info for the record.
    func getDetailInArray() -> Array<String>!
}

import UIKit

/// Record refers to each reacord that the Multi sensor returns to the server. All the
class TemperatureRecord: NSObject, DisplayableRecord {
    
    /// The temprature (Unit: °C)
    var temperature:Float!
    
    /// The air pressure (Unit: kPa),
    /// 1 kPa = 1,000 Pa, standard atmosphere = 101.325 kPa
    /// ref:wiki:https://en.wikipedia.org/wiki/Pascal_(unit)
    var airPressure:Float!
    
    /// The altitude (AKA: Height above sea level. Unit: Meter)
    var altitude:Float!
    
    /// The timestamp used to record the time of record
    var time:Date!

    /// - Parameters:
    ///     - thermometer: The temperature reading from Multi sensor
    ///     - barometer: The air pressure reading from Multi sensor
    ///     - altimeter: The altitude reading from Multi sensor
    ///     - timeInterval: The number of milliseconds since 1970.1.1
    init(thermometer:Float, barometer:Float, altimeter:Float, timeInterval:Int) {
        temperature = thermometer
        airPressure = barometer
        altitude = altimeter
        time = Date(timeIntervalSince1970: (Double(timeInterval) / 1000.0))
    }
    
    func getFormattedTime() -> String{
        let df = DateFormatter()
        let today = Date()
        // within today
        if Calendar.current.compare(today, to: self.time, toGranularity: .day) == ComparisonResult.orderedSame{
            df.dateFormat = "HH:mm:ss.SSSS"
        } else {
            df.dateFormat = "yyyy-MM-dd HH:mm:ss.SSSS"
        }
        df.timeZone = TimeZone(abbreviation: "AEDT")
        return df.string(from: time)
    }

    func getDetailInArray() -> Array<String>!{
        var result:[String] = []
        result.append("Time: \(getFormattedTime())")
        result.append("Temperature: \(temperature!)°C")
        result.append("Atmospheric pressure: \(airPressure!)kPa")
        result.append("Altitude: \(altitude!)meter")
        return result
    }
    
    func getDetailInString() -> String!{
        var result:String = ""
        for str in getDetailInArray(){
            if !result.isEmpty{
                result += "\n"
            }
            result += str
        }
        return result
    }
}
